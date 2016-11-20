﻿/*
 * [The "BSD license"]
 *  Copyright (c) 2016 Mike Lischke
 *  Copyright (c) 2013 Terence Parr
 *  Copyright (c) 2013 Dan McLaughlin
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. The name of the author may not be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 *  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "atn/RuleStopState.h"
#include "atn/Transition.h"
#include "atn/RuleTransition.h"
#include "atn/SingletonPredictionContext.h"
#include "atn/AbstractPredicateTransition.h"
#include "atn/WildcardTransition.h"
#include "atn/NotSetTransition.h"
#include "misc/IntervalSet.h"
#include "atn/ATNConfig.h"
#include "atn/EmptyPredictionContext.h"

#include "support/CPPUtils.h"

#include "atn/LL1Analyzer.h"

using namespace antlr4;
using namespace antlr4::atn;
using namespace antlrcpp;

LL1Analyzer::LL1Analyzer(const ATN &atn) : _atn(atn) {
}

std::vector<misc::IntervalSet> LL1Analyzer::getDecisionLookahead(ATNState *s) const {
  std::vector<misc::IntervalSet> look;

  if (s == nullptr) {
    return look;
  }

  look.resize(s->transitions.size()); // Fills all interval sets with defaults.
  for (size_t alt = 0; alt < s->transitions.size(); alt++) {
    bool seeThruPreds = false; // fail to get lookahead upon pred

    ATNConfig::Set lookBusy;
    antlrcpp::BitSet callRuleStack;
    _LOOK(s->transitions[alt]->target, nullptr, PredictionContext::EMPTY,
          look[alt], lookBusy, callRuleStack, seeThruPreds, false);
    
    // Wipe out lookahead for this alternative if we found nothing
    // or we had a predicate when we !seeThruPreds
    if (look[alt].size() == 0 || look[alt].contains(HIT_PRED)) {
      look[alt].clear();
    }
  }
  return look;
}

misc::IntervalSet LL1Analyzer::LOOK(ATNState *s, RuleContext *ctx) const {
  return LOOK(s, nullptr, ctx);
}

misc::IntervalSet LL1Analyzer::LOOK(ATNState *s, ATNState *stopState, RuleContext *ctx) const {
  misc::IntervalSet r;
  bool seeThruPreds = true; // ignore preds; get all lookahead
  Ref<PredictionContext> lookContext = ctx != nullptr ? PredictionContext::fromRuleContext(_atn, ctx) : nullptr;

  ATNConfig::Set lookBusy;
  antlrcpp::BitSet callRuleStack;
  _LOOK(s, stopState, lookContext, r, lookBusy, callRuleStack, seeThruPreds, true);

  return r;
}

void LL1Analyzer::_LOOK(ATNState *s, ATNState *stopState, Ref<PredictionContext> const& ctx, misc::IntervalSet &look,
  ATNConfig::Set &lookBusy, antlrcpp::BitSet &calledRuleStack, bool seeThruPreds, bool addEOF) const {
  
  Ref<ATNConfig> c = std::make_shared<ATNConfig>(s, 0, ctx);

  if (lookBusy.count(c) > 0) // Keep in mind comparison is based on members of the class, not the actual instance.
    return;

  lookBusy.insert(c);

  // ml: s can never be null, hence no need to check if stopState is != null.
  if (s == stopState) {
    if (ctx == nullptr) {
      look.add(Token::EPSILON);
      return;
    } else if (ctx->isEmpty() && addEOF) {
      look.add(Token::EOF);
      return;
    }
  }

  if (s->getStateType() == ATNState::RULE_STOP) {
    if (ctx == nullptr) {
      look.add(Token::EPSILON);
      return;
    } else if (ctx->isEmpty() && addEOF) {
      look.add(Token::EOF);
      return;
    }

    if (ctx != PredictionContext::EMPTY) {
      // run thru all possible stack tops in ctx
      for (size_t i = 0; i < ctx->size(); i++) {
        ATNState *returnState = _atn.states[ctx->getReturnState(i)];

        bool removed = calledRuleStack.test(returnState->ruleIndex);
        auto onExit = finally([removed, &calledRuleStack, returnState] {
          if (removed) {
            calledRuleStack.set(returnState->ruleIndex);
          }
        });

        calledRuleStack[returnState->ruleIndex] = false;
        _LOOK(returnState, stopState, ctx->getParent(i).lock(), look, lookBusy, calledRuleStack, seeThruPreds, addEOF);
      }
      return;
    }
  }

  size_t n = s->transitions.size();
  for (size_t i = 0; i < n; i++) {
    Transition *t = s->transitions[i];

    if (t->getSerializationType() == Transition::RULE) {
      if (calledRuleStack[(static_cast<RuleTransition*>(t))->target->ruleIndex]) {
        continue;
      }

      Ref<PredictionContext> newContext = SingletonPredictionContext::create(ctx, (static_cast<RuleTransition*>(t))->followState->stateNumber);
      auto onExit = finally([t, &calledRuleStack] {
        calledRuleStack[(static_cast<RuleTransition*>(t))->target->ruleIndex] = false;
      });

      calledRuleStack.set((static_cast<RuleTransition*>(t))->target->ruleIndex);
      _LOOK(t->target, stopState, newContext, look, lookBusy, calledRuleStack, seeThruPreds, addEOF);

    } else if (is<AbstractPredicateTransition *>(t)) {
      if (seeThruPreds) {
        _LOOK(t->target, stopState, ctx, look, lookBusy, calledRuleStack, seeThruPreds, addEOF);
      } else {
        look.add(HIT_PRED);
      }
    } else if (t->isEpsilon()) {
      _LOOK(t->target, stopState, ctx, look, lookBusy, calledRuleStack, seeThruPreds, addEOF);
    } else if (t->getSerializationType() == Transition::WILDCARD) {
      look.addAll(misc::IntervalSet::of(Token::MIN_USER_TOKEN_TYPE, (ssize_t)_atn.maxTokenType));
    } else {
      misc::IntervalSet set = t->label();
      if (!set.isEmpty()) {
        if (is<NotSetTransition*>(t)) {
          set = set.complement(misc::IntervalSet::of(Token::MIN_USER_TOKEN_TYPE, (ssize_t)_atn.maxTokenType));
        }
        look.addAll(set);
      }
    }
  }
}
