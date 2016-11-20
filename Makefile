all:

gen:
	bin/generate.sh

###################################################
# cpp vhdl parser

SRC_GENERATED = \
vhdlBaseListener.cpp \
vhdlBaseListener.h \
vhdlBaseVisitor.cpp \
vhdlBaseVisitor.h \
vhdlLexer.cpp \
vhdlLexer.h \
vhdlListener.cpp \
vhdlListener.h \
vhdlParser.cpp \
vhdlParser.h \
vhdlVisitor.cpp \
vhdlVisitor.h

$(SRC_GENERATED) : vhdl.g4
	bin/generate.sh

CFLAGS=-std=c++11 -I src -I antlr4-runtime-cpp -I antlr4-runtime-cpp/tree -g

%.o : %.cpp
	g++ $(CFLAGS) -c $< -o $@
	@echo -n "$@:"                               > $@.dep
	@g++ $(CFLAGS) -c $< -MM | sed -e 's/.*://' >> $@.dep


OBJ_VHDLPARSER_FILES = $(patsubst %.cpp,%.o,$(filter %.cpp,$(SRC_GENERATED)))

libvhdlparser.a: $(OBJ_VHDLPARSER_FILES)
	ar cr $@ $^; ranlib $@

###################################################
# cpp antlr4 runtime
ANTLRT_SUBDIRS= \
  antlr4-runtime-cpp \
  antlr4-runtime-cpp/atn \
  antlr4-runtime-cpp/dfa \
  antlr4-runtime-cpp/misc \
  antlr4-runtime-cpp/support \
  antlr4-runtime-cpp/tree \
  antlr4-runtime-cpp/tree/pattern \
  antlr4-runtime-cpp/tree/xpath \

SRC_ANTLRT_FILES= \
  $(foreach d,$(ANTLRT_SUBDIRS),$(wildcard $(d)/*.cpp))

OBJ_ANTLRT_FILES = $(patsubst %.cpp,%.o,$(SRC_ANTLRT_FILES))

antlr4-runtime-cpp/libantlr4-runtime.a: $(OBJ_ANTLRT_FILES)
	ar cr $@ $^; ranlib $@

###################################################
# misc
clean:
	-rm $(OBJ_ANTLRT_FILES) antlr4-runtime-cpp/*.a $(foreach d,$(ANTLRT_SUBDIRS),$(wildcard $(d)/*.dep)) libvhdlparser.a

-include $(foreach d,$(ANTLRT_SUBDIRS),$(wildcard $(d)/*.dep))
