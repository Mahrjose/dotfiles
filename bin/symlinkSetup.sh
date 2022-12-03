#! /usr/bin/sh

createSymLink() {

	if [ -f $2 ]; then
		echo "Removing $2"
		rm -f $2
	fi

	ln -vs $1 $2
}

# Check if .config directory exits or not
if [ ! -d $HOME/.config ]; then
	mkdir "$HOME/.config"

bash="$HOME/.dotfiles/bash"

# command outline - > ln -s from dest <
createSymLink "$bash/.bashrc" "$HOME/.bashrc"
createSymLink "$bash/.bash_profile" "$HOME/.bash_profile"

# =============================================================================== #
#                     		>> .config Directory <<                               #
# =============================================================================== #

config="$HOME/.dotfiles/.config"

# =============================== #
# 		Terminal Emulators		  #
# =============================== #

# Alacritty
##--> PATHS
alacritty="$config/alacritty"
dest_alacritty="$HOME/.config/alacritty"

##--> Symlinks
createSymLink "$alacritty/alacritty.yml" "$dest_alacritty/alacritty.yml"

# ================================ #
# 			Compositor		       #
# ================================ #

# Picom
##--> PATHS
picom="$config/picom"
dest_picom="$HOME/.config/picom"

##--> Symlinks
createSymLink "$picom/picom.conf" "$dest_picom/picom.conf"

# ================================ #
# 			   MENU  		       #
# ================================ #

# rofi
##--> PATHS
rofi="$config/rofi"
dest_rofi="$HOME/.config/rofi"

##--> Symlinks
createSymLink "$rofi/config.rasi" "$dest_rofi/config.rasi"

# ================================ #
# 		  Window Managers	       #
# ================================ #

# qtile
##--> PATHS
qtile="$config/qtile"
dest_qtile="$HOME/.config/qtile"

##--> Symlinks
createSymLink "$qtile/autostart.sh" "$dest_qtile/autostart.sh"
createSymLink "$qtile/colors.py" "$dest_qtile/colors.py"
createSymLink "$qtile/config.py" "$dest_qtile/config.py"