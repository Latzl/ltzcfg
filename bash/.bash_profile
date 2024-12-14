if [ ! -n "$BASH_VERSION" ]; then
	return
fi

if [ -f "$HOME/.bashrc" ]; then
	source $HOME/.bashrc
fi

if [ -d "$HOME/.bash_profile.d" ]; then
	for profile in $HOME/.bash_profile.d/*; do
		source $profile
	done
fi

if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi
