#!/usr/bin/sh

mv() {

   command mv $1 $2 &> /dev/null
}

#change Directory Name
mv "$HOME/dotfiles" "$HOME/.dotfiles"

# Execute symlinksetup script
chmod +x $HOME/.dotfiles/bin/symlinkSetup.sh
$HOME/.dotfiles/bin/symlinkSetup.sh

