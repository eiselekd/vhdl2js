#!/bin/bash
set -x

bin/antlr4.6 -Dlanguage=Cpp vhdl.g4 -visitor -o src -package vhdl
