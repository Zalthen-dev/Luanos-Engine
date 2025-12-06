#!/usr/bin/env python3

# Usage: python3 dump_raylib_symbols.py libraylib.so > raylib_functions.lua

import subprocess
import sys
import re

file = sys.argv[1]

# Run readelf
out = subprocess.check_output(["readelf", "-Ws", file], text=True)

symbols = set()

for line in out.splitlines():
    # Example format:
    #  1234: 00000000     0 FUNC    GLOBAL DEFAULT 12 InitWindow
    parts = line.split()
    if len(parts) < 8:
        continue

    # Only keep FUNC GLOBAL symbols
    if parts[3] != "FUNC":
        continue

    name = parts[-1]

    # Filters for raylib noise
    if name.startswith("_"):
        continue
    if name.startswith("llvm"):
        continue
    if name.startswith("std::"):
        continue
    if name.startswith("CXX"):
        continue
    if name.startswith("GL"):
        continue
    if name.startswith("rl"):
        continue  # rlgl and internal stuff
    if name.startswith("khr"):
        continue
    if name.startswith("glad_"):
        continue
    if name.startswith("cgltf_"):
        continue
    if name.startswith("drmp3_"):
        continue
    if name.startswith("drwav_"):
        continue
    if name.startswith("glfw"):
        continue
    if name.startswith("jar_"):
        continue
    if name.startswith("ma_"):
        continue
    if name.startswith("par_"):
        continue
    if name.startswith("qoi_"):
        continue
    if name.startswith("stb"):
        continue
    if name.startswith("xm"):
        continue

    # Keep C-style names
    if re.match(r"^[A-Za-z_][A-Za-z0-9_]*$", name):
        symbols.add(name)

# Sort alphabetically
symbols = sorted(symbols)

# Output as Luau table
for s in symbols:
    print(f'{s} = lib.{s},')
