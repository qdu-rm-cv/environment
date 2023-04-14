#! /bin/bash

CUR_DIR=$(
  cd "$(dirname "$0")/"
  pwd
)

source ${CUR_DIR}/functions.sh
source_code_install

exit 0
