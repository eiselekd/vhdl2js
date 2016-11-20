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

#include "atn/ActionTransition.h"

using namespace antlr4::atn;

ActionTransition::ActionTransition(ATNState *target, size_t ruleIndex)
  : Transition(target), ruleIndex(ruleIndex), actionIndex(INVALID_INDEX), isCtxDependent(false) {
}

ActionTransition::ActionTransition(ATNState *target, size_t ruleIndex, size_t actionIndex, bool isCtxDependent)
  : Transition(target), ruleIndex(ruleIndex), actionIndex(actionIndex), isCtxDependent(isCtxDependent) {
}

Transition::SerializationType ActionTransition::getSerializationType() const {
  return ACTION;
}

bool ActionTransition::isEpsilon() const {
  return true; // we are to be ignored by analysis 'cept for predicates
}

bool ActionTransition::matches(size_t /*symbol*/, size_t /*minVocabSymbol*/, size_t /*maxVocabSymbol*/) const {
  return false;
}

std::string ActionTransition::toString() const {
  return " ACTION " + Transition::toString() + " { ruleIndex: " + std::to_string(ruleIndex) + ", actionIndex: " +
  std::to_string(actionIndex) + ", isCtxDependent: " + std::to_string(isCtxDependent) + " }";
}
