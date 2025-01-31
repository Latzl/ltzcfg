#!/bin/bash

if ! which rsync &>/dev/null; then
	echo "rsync not found, required" >&2
	exit 1
fi

if ! [ -d "${HOME}/.confiles/mods/base" ]; then
	echo "base confiles not found" >&2
	exit 1
fi

get_usage() {
	echo "Usage: $0 {status|apply} [-v|--verbose] [dst_dir]"
}

OPT_VERBOSE=false

ARGS="$(getopt -l verbose -o v -- "$@")"
if [ $? -ne 0 ]; then
	echo "$(get_usage)" >&2
	exit 1
fi

eval set -- "$ARGS"

while true; do
	case "$1" in
	-v | --verbose)
		OPT_VERBOSE=true
		shift
		;;
	--)
		shift
		break
		;;
	*)
		echo "Internal error: getopt problem" >&2
		exit 1
		;;
	esac
done

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

DST_DIR_PROVIDED=''
DST_DIR=''
IS_DST_REMOTE=false
DST_HOST=''
DST_UNAME=''
DST_OS=''
DST_ARCH=''

if [ -n "$2" ]; then
	DST_DIR_PROVIDED=true
else
	DST_DIR=false
fi

if $DST_DIR_PROVIDED; then
	DST_DIR="$2"
else
	DST_DIR="$HOME"
fi

if grep -q ":" <<<"$DST_DIR"; then # remote
	IS_DST_REMOTE=true
else
	IS_DST_REMOTE=false
fi

if $IS_DST_REMOTE; then
	DST_HOST="$(cut -d: -f1 <<<"$DST_DIR")"
else
	DST_HOST="$HOSTNAME"
fi

if $DST_DIR_PROVIDED; then
	if grep -q ":" <<<"$DST_DIR"; then # remote
		DST_UNAME=$(ssh $DST_HOST 'uname -sm')
	else
		DST_UNAME=$(uname -sm)
	fi
else
	DST_UNAME=$(uname -sm)
fi

DST_OS="$(awk '{print $1}' <<<$DST_UNAME)"
DST_ARCH="$(awk '{print $2}' <<<$DST_UNAME)"

# infos
if $OPT_VERBOSE; then
	echo "DST_DIR=$DST_DIR"
	echo "DST_UNAME=$DST_UNAME"
	echo "DST_OS=$DST_OS"
	echo "DST_ARCH=$DST_ARCH"
fi

get_mod_bin_dir(){
	local mod_dir="$1"
	local mod_name="$(basename "$mod_dir")"
	local mod_bin_dir="${HOME}/.confiles/mods/.${mod_name}-bin/${DST_OS}/${DST_ARCH}"
	if [ -d "$mod_bin_dir" ]; then
		echo "$mod_bin_dir"
		return 0
	fi
	return 1
}

cf_status() {
	local mod_dir="$1"
	local dst_dir="$2"
	if ! [ -n "$dst_dir" ]; then
		dst_dir="$HOME"
	fi

	local cmd="rsync -avO --no-o --no-g -ni ${mod_dir}/home/ ${dst_dir}/"
	# echo "$cmd"
	eval "$cmd"
}

cf_apply() {
	local mod_dir="$1"
	local dst_dir="$2"
	if ! [ -n "$dst_dir" ]; then
		dst_dir="$HOME"
	fi

	rsync -avO --no-o --no-g "${mod_dir}/home/" "${dst_dir}/"
}

status_all() {
	local dst_dir="$1"
	for mod_dir in "${HOME}/.confiles/mods/"*; do
		echo ">>> $mod_dir"
		cf_status "$mod_dir" "$dst_dir"

		# bin
		local mod_bin_dir="$(get_mod_bin_dir "$mod_dir")"
		if [ -n "$mod_bin_dir" ]; then
			echo ">>> $mod_bin_dir"
			cf_status "$mod_bin_dir" "$dst_dir"
		fi
	done
}

apply_all() {
	local dst_dir="$1"
	for mod_dir in "${HOME}/.confiles/mods/"*; do
		echo ">>> $mod_dir"
		cf_apply "$mod_dir" "$dst_dir"

		# bin
		local mod_bin_dir="$(get_mod_bin_dir "$mod_dir")"
		if [ -n "$mod_bin_dir" ]; then
			echo ">>> $mod_bin_dir"
			cf_apply "$mod_bin_dir" "$dst_dir"
		fi
	done
}

# main
case "$1" in
status)
	status_all "$2"
	;;
apply)
	apply_all "$2"
	;;
*)
	echo "$(get_usage)" >&2
	exit 1
	;;
esac
