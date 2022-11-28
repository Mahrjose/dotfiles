#!/usr/bin/bash

mv() {

   command mv $1 $2 &> /dev/null
}


#change Directory Name
mv "$HOME/dotfiles" "$HOME/.dotfiles"

# Copy symlinksetup script to $HOME & execute
cp $HOME/.dotfiles/bin/symlinkSetup.sh $HOME/symlinkSetup.sh
chmod +x $HOME/symlinkSetup.sh
./symlinkSetup.sh

rm $HOME/symlinkSetup.sh
