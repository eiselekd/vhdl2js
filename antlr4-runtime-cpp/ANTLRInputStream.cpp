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

#include "Exceptions.h"
#include "misc/Interval.h"
#include "IntStream.h"

#include "support/StringUtils.h"
#include "support/CPPUtils.h"

#include "ANTLRInputStream.h"

using namespace antlr4;
using namespace antlrcpp;

using misc::Interval;

ANTLRInputStream::ANTLRInputStream(const std::string &input) {
  InitializeInstanceFields();
  load(input);
}

ANTLRInputStream::ANTLRInputStream(const char data_[], size_t numberOfActualCharsInArray)
  : ANTLRInputStream(std::string(data_, numberOfActualCharsInArray)) {
}

ANTLRInputStream::ANTLRInputStream(std::istream &stream) {
  InitializeInstanceFields();
  load(stream);
}

void ANTLRInputStream::load(const std::string &input) {
  // Remove the UTF-8 BOM if present.
  const char bom[4] = "\xef\xbb\xbf";
  if (input.compare(0, 3, bom, 3) == 0)
    _data = antlrcpp::utfConverter.from_bytes(input.data() + 3, input.data() + input.size());
  else
    _data = antlrcpp::utfConverter.from_bytes(input);
  p = 0;
}

void ANTLRInputStream::load(std::istream &stream) {
  if (!stream.good() || stream.eof()) // No fail, bad or EOF.
    return;

  _data.clear();

  std::string s((std::istreambuf_iterator<char>(stream)), std::istreambuf_iterator<char>());
  load(s);
}

void ANTLRInputStream::reset() {
  p = 0;
}

void ANTLRInputStream::consume() {
  if (p >= _data.size()) {
    assert(LA(1) == IntStream::EOF);
    throw IllegalStateException("cannot consume EOF");
  }

  if (p < _data.size()) {
    p++;
  }
}

size_t ANTLRInputStream::LA(ssize_t i) {
  if (i == 0) {
    return 0; // undefined
  }

  ssize_t position = (ssize_t)p;
  if (i < 0) {
    i++; // e.g., translate LA(-1) to use offset i=0; then _data[p+0-1]
    if ((position + i - 1) < 0) {
      return IntStream::EOF; // invalid; no char before first char
    }
  }

  if ((position + i - 1) >= (ssize_t)_data.size()) {
    return IntStream::EOF;
  }

  return _data[(size_t)(position + i - 1)];
}

size_t ANTLRInputStream::LT(ssize_t i) {
  return LA(i);
}

size_t ANTLRInputStream::index() {
  return p;
}

size_t ANTLRInputStream::size() {
  return _data.size();
}

// Mark/release do nothing. We have entire buffer.
ssize_t ANTLRInputStream::mark() {
  return -1;
}

void ANTLRInputStream::release(ssize_t /* marker */) {
}

void ANTLRInputStream::seek(size_t index) {
  if (index <= p) {
    p = index; // just jump; don't update stream state (line, ...)
    return;
  }
  // seek forward, consume until p hits index or n (whichever comes first)
  index = std::min(index, _data.size());
  while (p < index) {
    consume();
  }
}

std::string ANTLRInputStream::getText(const Interval &interval) {
  if (interval.a < 0 || interval.b < 0) {
    return "";
  }

  size_t start = interval.a;
  size_t stop = interval.b;


  if (stop >= _data.size()) {
    stop = _data.size() - 1;
  }

  size_t count = stop - start + 1;
  if (start >= _data.size()) {
    return "";
  }

  return antlrcpp::utfConverter.to_bytes(_data.substr(start, count));
}

std::string ANTLRInputStream::getSourceName() const {
  if (name.empty()) {
    return IntStream::UNKNOWN_SOURCE_NAME;
  }
  return name;
}

std::string ANTLRInputStream::toString() const {
  return antlrcpp::utfConverter.to_bytes(_data);
}

void ANTLRInputStream::InitializeInstanceFields() {
  p = 0;
}
