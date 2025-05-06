#!/usr/bin/env sh
set -uo pipefail

# windows | linux
: ${OS_TYPE=windows}

SHARED_FLAGS="-debug -thread-count:4 -error-pos-style:unix -define:RAYLIB_SHARED=true -microarch:native -linker:lld"
datetime=$(date '+%d%m%H%M%S')

build_game_lib ()
{
  ext=".so"
  [ $OS_TYPE = "windows" ] && ext=".dll"

  out_file="game_lib$ext"

  odin build game -out:$out_file $SHARED_FLAGS -build-mode:shared -no-entry-point -extra-linker-flags:"-PDB:game_$datetime.pdb"
}

build_platform ()
{
  ext=".bin"
  [ $OS_TYPE = "windows" ] && ext=".exe"

  out_file="platform$ext"

  odin build platforms/platform_raylib.odin -file -out:$out_file $SHARED_FLAGS
}

rm *.pdb
rm *.tmp
build_game_lib
build_platform

