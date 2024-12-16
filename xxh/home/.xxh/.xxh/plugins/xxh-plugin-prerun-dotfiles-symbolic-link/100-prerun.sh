CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $CURR_DIR/home
for item in $(shopt -s dotglob && cd $CURR_DIR/home && find * -maxdepth 0); do

  target_item=$XXH_HOME/$item
  if [[ $XXH_VERBOSE == '1' || $XXH_VERBOSE == '2' ]]; then
    echo "xxh-plugin-prerun-dotfiles-link: link file $target_item -> $CURR_DIR/home/$item"
  fi

  ln -sf "$CURR_DIR/home/$item" "$target_item"
done
cd $XXH_HOME
