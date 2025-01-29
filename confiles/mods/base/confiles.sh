#!/bin/bash

if ! which rsync &>/dev/null; then
	echo "rsync not found, required" >&2
	exit 1
fi

if ! [ -d "${HOME}/.confiles/mods/base" ]; then
	echo "base confiles not found" >&2
	exit 1
fi

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

cf_status() {
	local mod_dir="$1"
	local dst_dir="$2"
	if ! [ -n "$dst_dir" ]; then
		dst_dir="$HOME"
	fi

	local cmd="rsync -av --no-o --no-g -niO ${mod_dir}/home/ ${dst_dir}/"
	# echo "$cmd"
	eval "$cmd"
}

cf_apply() {
	local mod_dir="$1"
	local dst_dir="$2"
	if ! [ -n "$dst_dir" ]; then
		dst_dir="$HOME"
	fi

	rsync -av --no-o --no-g "${mod_dir}/home/" "${dst_dir}/"
}

status_all() {
	local dst_dir="$1"
	shopt -s dotglob
	for mod_dir in "${HOME}/.confiles/mods/"*; do
		echo ">>> $mod_dir"
		cf_status "$mod_dir" "$dst_dir"
	done
}

apply_all() {
	local dst_dir="$1"
	shopt -s dotglob
	for mod_dir in "${HOME}/.confiles/mods/"*; do
		echo ">>> $mod_dir"
		cf_apply "$mod_dir" "$dst_dir"
	done
}

case "$1" in
status)
	case "$2" in
	--single-mod|-s)
		cf_status "$3" "$4"
		;;
	*)
		status_all "$2"
		;;
	esac
	;;
apply)
	case "$2" in
	--single-mod|-s)
		cf_apply "$3" "$4"
		;;
	*)
		apply_all "$2"
		;;
	esac
	;;
*)
	echo "Usage: $0 {status|apply} [--single-mod|-s mod_dir] [dst_dir]" >&2
	exit 1
	;;
esac
