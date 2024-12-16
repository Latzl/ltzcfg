#!/bin/bash

if ! which xxh > /dev/null; then
	echo 'xxh not installed'
	exit 1
fi

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LTZCFG_ROOT_DIR="$(realpath ${CURR_DIR}/..)"
LTZCFG_XXH_HOME="${LTZCFG_ROOT_DIR}/xxh/home/.xxh"
XXH_HOME=~/.xxh

PLUGIN_NAME='xxh-shell-bash'
xxh +RI ${PLUGIN_NAME}+path+${LTZCFG_XXH_HOME}/.xxh/shells/${PLUGIN_NAME}
PLUGIN_NAME='xxh-plugin-bash-basic'
xxh +RI ${PLUGIN_NAME}+path+${LTZCFG_XXH_HOME}/.xxh/plugins/${PLUGIN_NAME}
PLUGIN_NAME='xxh-plugin-bash-example'
xxh +RI ${PLUGIN_NAME}+path+${LTZCFG_XXH_HOME}/.xxh/plugins/${PLUGIN_NAME}

# dotfiles
shopt -s dotglob
# symbolic link
PLUGIN_NAME='xxh-plugin-prerun-dotfiles-symbolic-link'
DST_DIR="${XXH_HOME}/.xxh/plugins/${PLUGIN_NAME}/build/home"
xxh +RI ${PLUGIN_NAME}+path+${LTZCFG_XXH_HOME}/.xxh/plugins/${PLUGIN_NAME}
cp -ir ${LTZCFG_ROOT_DIR}/bash/home/* "${DST_DIR}/"
cp -ir ${LTZCFG_ROOT_DIR}/vim/home/* "${DST_DIR}/"
cp -ir "${LTZCFG_ROOT_DIR}/tmux/home/.tmux.conf" "${DST_DIR}/"
cp -ir "${LTZCFG_ROOT_DIR}/tmux/home/.tmux.conf.plugins" "${DST_DIR}/"

# put once
PLUGIN_NAME='xxh-plugin-prerun-dotfiles-put-once'
DST_DIR="${XXH_HOME}/.xxh/plugins/${PLUGIN_NAME}/build/home"
xxh +RI ${PLUGIN_NAME}+path+${LTZCFG_XXH_HOME}/.xxh/plugins/${PLUGIN_NAME}
cp -ir "${LTZCFG_ROOT_DIR}/tmux/home/.tmux" "${DST_DIR}/"
