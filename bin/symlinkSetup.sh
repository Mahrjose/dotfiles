#!/usr/bin/sh

createSymLink() {

	if [ -f $2 ]; then
		echo "Removing $2"
		rm -f $2
	fi

	ln -vs $1 $2
}

bash="$HOME/.dotfiles/bash"

# command outline - > ln -s from dest <
createSymLink "$bash/.bashrc" "$HOME/.bashrc"
createSymLink "$bash/.bash_profile" "$HOME/.bash_profile"
