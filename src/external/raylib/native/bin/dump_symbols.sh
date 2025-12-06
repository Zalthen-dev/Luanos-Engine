#!/usr/bin/env bash

# Usage: ./dump_raylib_symbols.sh libraylib.so > raylib_functions.lua

FILE="$1"

readelf -Ws "$FILE" \
  | awk '
        $4 == "FUNC" && $7 == "GLOBAL" { print $8 }
    ' \
  | grep -v '^_' \
  | grep -v '^__' \
  | grep -v 'GLOBAL_' \
  | grep -v 'std::' \
  | grep -v 'CXX' \
  | grep -v 'GL' \
  | grep -v '^llvm' \
  | grep -v '^_fini' \
  | grep -v '^_init' \
  | grep -v '^raylibInternal' \
  | grep -v '^khr' \
  | grep -v '^rl' \
  | sort -u \
  | awk '
        BEGIN { print "local functions = {" }
        { print "    \"" $0 "\"," }
        END { print "}\nreturn functions" }
    '
