CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ $XDG_CACHE_HOME ]]; then
  done_file=$XDG_CACHE_HOME/xxh-plugin-prerun-dotfiles-put-once-done
else
  done_file=$XXH_HOME/.xxh-plugin-prerun-dotfiles-put-once-done
fi

PUT_ONCE_DONE=false
if [ -f $done_file ]; then
	PUT_ONCE_DONE=true
fi

SRC_DIR=${CURR_DIR}/home
DST_DIR=${XXH_HOME}

_parse_prerun_list(){
	local src_rpath="$1"
	local _type="$2"

	if [ -z $src_rpath ]; then
		echo "empty src_rpath" >&2
		return 1
	fi
	
	local src_path=${SRC_DIR}/${src_rpath}
	local dst_path=${DST_DIR}/${src_rpath}
	case $_type in
		l)  # symbolic link
			if [ ! -e $dst_path ]; then
				# just ln if dst_path is not exist
				mkdir -p $(dirname ${dst_path})
				ln -sf $src_path $dst_path
			else
				local src_path_real=$(realpath $src_path)
				local dst_path_real=$(realpath $dst_path)
				if [ "$src_path_real" != "$dst_path_real" ]; then
					# error if dst_path not link to src_path
					echo "$dst_path is already exist but not link to xxh dotfiles" >&2
				fi
			fi
			;;
		o)  # put once
			if ! $PUT_ONCE_DONE && [ ! -e $dst_path ]; then
				mkdir -p $(dirname ${dst_path})
				cp -r $src_path $dst_path
			fi
			;;
		*)
			echo "Unknown _type: $_type" >&2
			;;
	esac
}

for list in $(find ${CURR_DIR}/prerun.d/ -type f); do
	while IFS= read -r line
	do
		line_trimed=$(echo "$line" | sed 's/#.*$//g' | xargs)
		if [ -z "$line_trimed" ]; then
			continue
		fi
		IFS=';' read -r -a arr <<< $line_trimed
		_parse_prerun_list "${arr[0]}" "${arr[1]}"
	done < $list
done

mkdir -p `dirname $done_file`
echo 'done' > $done_file

cd $XXH_HOME
