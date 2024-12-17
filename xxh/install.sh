#!/bin/bash

if ! which xxh > /dev/null; then
	echo 'xxh not installed'
	exit 1
fi

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
LTZCFG_ROOT_DIR="$(realpath ${CURR_DIR}/..)"
LTZCFG_XXH_HOME="${LTZCFG_ROOT_DIR}/xxh/home/.xxh"
LTZCFG_XXH_PKG_DIR_SHELL="${LTZCFG_XXH_HOME}/.xxh/shells"
LTZCFG_XXH_PKG_DIR_PLUGINS="${LTZCFG_XXH_HOME}/.xxh/plugins"
XXH_HOME=~/.xxh
XXH_PKG_DIR_SHELL="${XXH_HOME}/.xxh/shells"
XXH_PKG_DIR_PLUGINS="${XXH_HOME}/.xxh/plugins"

for pkg_path in $(find {${LTZCFG_XXH_PKG_DIR_SHELL},${LTZCFG_XXH_PKG_DIR_PLUGINS}}/* -maxdepth 0 -type d); do
	echo ${pkg_path}
	pkg_name="$(basename ${pkg_path})"
	xxh +RI ${pkg_name}+path+${pkg_path}
done

# dotfiles
shopt -s dotglob
pkg_name='xxh-plugin-prerun-dotfiles'
dst_dir="${XXH_PKG_DIR_PLUGINS}/${pkg_name}/build/home"
xxh +RI ${pkg_name}+path+${LTZCFG_XXH_PKG_DIR_PLUGINS}/${pkg_name}
cp -irvL ${LTZCFG_ROOT_DIR}/dotfiles/linux/home/* "${dst_dir}/"
