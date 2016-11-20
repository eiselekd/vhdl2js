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

#pragma once

#include "antlr4-common.h"

namespace antlr4 {
namespace misc {

  // Helpers to convert certain unsigned symbols (e.g. Token::EOF) to their original numeric value (e.g. -1)
  // and vice version. This is needed mostly for intervals to keep their original order and for toString()
  // methods to print the original numeric value (e.g. for tests).
  size_t numericToSymbol(ssize_t v);
  ssize_t symbolToNumeric(size_t v);

  /// An immutable inclusive interval a..b
  class ANTLR4CPP_PUBLIC Interval {
  public:
    static const Interval INVALID;

    // Must stay signed to guarantee the correct sort order.
    ssize_t a;
    ssize_t b;

    Interval();
    explicit Interval(size_t a_, size_t b_); // For unsigned -> signed mappings.
    Interval(ssize_t a_, ssize_t b_, bool autoExtend = false); // Automatically extend a value of 0xFFFF to 0x10FFFF.
    virtual ~Interval() {};

    /// return number of elements between a and b inclusively. x..x is length 1.
    ///  if b < a, then length is 0.  9..10 has length 2.
    virtual size_t length() const;

    bool operator == (const Interval &other) const;

    virtual size_t hashCode() const;

    /// <summary>
    /// Does this start completely before other? Disjoint </summary>
    virtual bool startsBeforeDisjoint(const Interval &other) const;

    /// <summary>
    /// Does this start at or before other? Nondisjoint </summary>
    virtual bool startsBeforeNonDisjoint(const Interval &other) const;

    /// <summary>
    /// Does this.a start after other.b? May or may not be disjoint </summary>
    virtual bool startsAfter(const Interval &other) const;

    /// <summary>
    /// Does this start completely after other? Disjoint </summary>
    virtual bool startsAfterDisjoint(const Interval &other) const;

    /// <summary>
    /// Does this start after other? NonDisjoint </summary>
    virtual bool startsAfterNonDisjoint(const Interval &other) const;

    /// <summary>
    /// Are both ranges disjoint? I.e., no overlap? </summary>
    virtual bool disjoint(const Interval &other) const;

    /// <summary>
    /// Are two intervals adjacent such as 0..41 and 42..42? </summary>
    virtual bool adjacent(const Interval &other) const;

    virtual bool properlyContains(const Interval &other) const;

    /// <summary>
    /// Return the interval computed from combining this and other </summary>
    virtual Interval Union(const Interval &other) const;

    /// <summary>
    /// Return the interval in common between this and o </summary>
    virtual Interval intersection(const Interval &other) const;

    virtual std::string toString() const;

  private:
  };

} // namespace atn
} // namespace antlr4
