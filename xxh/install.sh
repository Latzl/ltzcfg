#!/bin/bash

if ! which xxh > /dev/null; then
	echo 'xxh not installed'
	exit 1
fi

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LTZCFG_ROOT_DIR="$(realpath ${CURR_DIR}/..)"
XHH_HOME=~/.xxh

xxh +RI xxh-shell-bash+path+${CURR_DIR}/shells/xxh-shell-bash
xxh +RI xxh-plugin-bash-basic+path+${CURR_DIR}/plugins/xxh-plugin-bash-basic
xxh +RI xxh-plugin-bash-example+path+${CURR_DIR}/plugins/xxh-plugin-bash-example

# dotfiles
# symbolic link
PLUGIN_NAME='xxh-plugin-prerun-dotfiles-symbolic-link'
DST_DIR="${XHH_HOME}/.xxh/plugins/${PLUGIN_NAME}/build/home"
xxh +RI ${PLUGIN_NAME}+path+${CURR_DIR}/plugins/${PLUGIN_NAME}
cp -iv "${LTZCFG_ROOT_DIR}/bash/.bash_profile" "${DST_DIR}/"
cp -ivr "${LTZCFG_ROOT_DIR}/bash/.bash_profile.d" "${DST_DIR}/"
cp -iv "${LTZCFG_ROOT_DIR}/bash/.bashrc" "${DST_DIR}/"
cp -ivr "${LTZCFG_ROOT_DIR}/bash/.bashrc.d" "${DST_DIR}/"
cp -iv "${LTZCFG_ROOT_DIR}/vim/.vimrc" "${DST_DIR}/"
cp -iv "${LTZCFG_ROOT_DIR}/tmux/.tmux.conf" "${DST_DIR}/"
cp -iv "${LTZCFG_ROOT_DIR}/tmux/.tmux.conf.plugins" "${DST_DIR}/"

# put once
PLUGIN_NAME='xxh-plugin-prerun-dotfiles-put-once'
DST_DIR="${XHH_HOME}/.xxh/plugins/${PLUGIN_NAME}/build/home"
xxh +RI ${PLUGIN_NAME}+path+${CURR_DIR}/plugins/${PLUGIN_NAME}
cp -ivr "${LTZCFG_ROOT_DIR}/tmux/.tmux" "${DST_DIR}/"
