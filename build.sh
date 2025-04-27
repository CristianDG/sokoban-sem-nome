#!/usr/bin/env sh
set -euo pipefail

# windows | linux
: ${OS_TYPE=windows}

SHARED_FLAGS="-debug -thread-count:4 -error-pos-style:unix"

build_game_lib ()
{
  ext=".so"
  [ $OS_TYPE = "windows" ] && ext=".dll"

  out_file="game_lib$ext"

  odin build game -out:$out_file -build-mode:shared -no-entry-point $SHARED_FLAGS
}

build_platform ()
{
  ext=".bin"
  [ $OS_TYPE = "windows" ] && ext=".exe"

  out_file="out$ext"

  rm *.pdb
  datetime=$(date '+%d%m%H%M%S')

  odin build platform_raylib.odin -file -out:$out_file $SHARED_FLAGS
}

build_game_lib
build_platform

