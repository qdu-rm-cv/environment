#! /usr/bin/bash

CUR_PATH=$(
  cd "$(dirname "$0")/"
  pwd
)

source $CUR_PATH/functions.sh
packs=$(menu)
install "${packs[*]}"
exit 0
