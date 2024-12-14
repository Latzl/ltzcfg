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
DOTFILES='xxh-plugin-prerun-dotfiles-symbolic-link'
DOTFILES_HOME="${XHH_HOME}/.xxh/plugins/${DOTFILES}/build/home"
xxh +RI ${DOTFILES}+path+${CURR_DIR}/plugins/${DOTFILES}
cp -iv "${LTZCFG_ROOT_DIR}/bash/.bash_profile" "${DOTFILES_HOME}/"
cp -ivr "${LTZCFG_ROOT_DIR}/bash/.bash_profile.d" "${DOTFILES_HOME}/"
cp -iv "${LTZCFG_ROOT_DIR}/bash/.bashrc" "${DOTFILES_HOME}/"
cp -ivr "${LTZCFG_ROOT_DIR}/bash/.bashrc.d" "${DOTFILES_HOME}/"
cp -iv "${LTZCFG_ROOT_DIR}/vim/.vimrc" "${DOTFILES_HOME}/"
cp -iv "${LTZCFG_ROOT_DIR}/tmux/.tmux.conf" "${DOTFILES_HOME}/"
cp -iv "${LTZCFG_ROOT_DIR}/tmux/.tmux.conf.plugins" "${DOTFILES_HOME}/"
