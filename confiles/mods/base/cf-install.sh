#!/bin/bash

MOD_NAME=base

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source ../../cf-base.sh

mkdir -p ~/bin
# install ${CURR_DIR}/confiles.sh ~/bin/
ln -svf "${CURR_DIR}/confiles.sh" ~/bin/
