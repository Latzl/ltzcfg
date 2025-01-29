#!/bin/bash

MOD_NAME=

if ! [ -n "$MOD_NAME" ]; then
	echo "MOD_NAME not set" >&2
	exit 1
fi

if ! which rsync &>/dev/null; then
	echo "rsync not found, required" >&2
	exit 1
fi

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
MOD_CF_DIR=${CURR_DIR}
MOD_CF_HOME=${MOD_CF_DIR}/home
CF_DIR=${HOME}/.confiles
CF_MOD_DIR=${CF_DIR}/mods/${MOD_NAME}

if [ -d "${CF_MOD_DIR}" ]; then
	rm -r "${CF_MOD_DIR}"
fi
mkdir -p "${CF_MOD_DIR}"
ln -sv "${MOD_CF_HOME}" "${CF_MOD_DIR}/home"