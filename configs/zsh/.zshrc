
#  ███████╗███████╗██╗  ██╗██████╗  ██████╗
#  ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#    ███╔╝ ███████╗███████║██████╔╝██║
#   ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#  ███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#
#  Author : Mirza Mahrab Hossain
#  Github : https://github.com/mahrjose


########################################################
# ----------------   OH-MY-ZSH   -------------------- #
########################################################

ZSH=/usr/share/oh-my-zsh/
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

plugins=( git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting )
source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


########################################################
# ------------------   EXPORTS   -------------------- #
########################################################

export PATH="$HOME/.local/bin:$HOME/Hub/Workshop/dotfiles/scripts/personal:$PATH"

export EDITOR=vim
export VISUAL=code

export HISTFILESIZE=10000
export HISTSIZE=1000
export HISTCONTROL=erasedups:ignoredups:ignorespace


########################################################
# ------------------   ALIASES   -------------------- #
########################################################

# -- General --
alias c='clear'
alias edit='subl'
alias vi='vim'
alias svi='sudo vim'
alias svim='sudo vim'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias ping='ping -c 10'
alias less='less -R'
alias da='date "+%Y-%m-%d %A %T %Z"'

# -- Listing --
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'

# -- Navigation --
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias bd='cd "$OLDPWD"'
alias home='cd ~'

# -- Package Management --
alias un='$aurhelper -Rns'
alias up='$aurhelper -Syu'
alias pl='$aurhelper -Qs'
alias pa='$aurhelper -Ss'
alias pc='$aurhelper -Sc'
alias po='$aurhelper -Qtdq | $aurhelper -Rns -'
alias update='sudo pacman -Sy'
alias upgrade='sudo pacman -Syu'

# -- Apps --
alias vc='code'
alias ssh='/home/mahrjose/Hub/Core/Scripts/ssh-modified.sh'
alias bw='node --no-deprecation /usr/bin/bw'


########################################################
# -----------------   FUNCTIONS   ------------------- #
########################################################

# Create and enter a directory
mkcd() {
    mkdir -p "$1" && cd "$1" || echo "mkcd: failed to create or enter '$1'"
}

# Extract any archive format
extract() {
    if [ ! -f "$1" ]; then
        echo "extract: '$1' is not a valid file"
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xf  "$1" ;;
        *.zip)     unzip "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.7z)      7z x "$1" ;;
        *) echo "extract: unknown format '$1'" ;;
    esac
}

# Display network info
netinfo() {
    echo "========== Network Information =========="
    echo "IP Addresses:"
    ip addr show | awk '/inet / {print $2}'
    echo "-----------------------------------------"
    echo "Default Gateway:"
    ip route show default | awk '{print $3}'
    echo "-----------------------------------------"
    echo "DNS Servers:"
    grep "nameserver" /etc/resolv.conf | awk '{print $2}'
    echo "-----------------------------------------"
    echo "Active Connections (top 10):"
    ss -tunap | head -n 10
    echo "========================================="
}


########################################################
# ------------------   SYSTEM   --------------------- #
########################################################

# Detect AUR wrapper
if pacman -Qi yay &>/dev/null; then
    aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
    aurhelper="paru"
fi

# Install packages (auto-detect official vs AUR)
function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    [[ ${#arch[@]} -gt 0 ]] && sudo pacman -S "${arch[@]}"
    [[ ${#aur[@]} -gt 0 ]] && ${aurhelper} -S "${aur[@]}"
}

# Suggest package when command not found
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}


########################################################
# -----------------   BITWARDEN   ------------------- #
########################################################

# Keep Bitwarden session alive across terminals
_BW_SESSION_FILE="$HOME/.cache/bw_session"
_BW_MASTER_FILE="$HOME/.cache/bw_master"

bw-unlock() {
    local session
    if [[ -f "$_BW_MASTER_FILE" ]]; then
        session="$(BW_PASSWORD="$(cat "$_BW_MASTER_FILE")" node --no-deprecation /usr/bin/bw unlock --passwordenv BW_PASSWORD --raw 2>/dev/null)"
    fi
    if [[ -n "$session" ]]; then
        export BW_SESSION="$session"
        echo "$session" > "$_BW_SESSION_FILE"
        chmod 600 "$_BW_SESSION_FILE"
    fi
}

# Load cached session - only unlock if no session file exists
if [[ -f "$_BW_SESSION_FILE" ]]; then
    export BW_SESSION="$(cat "$_BW_SESSION_FILE")"
else
    bw-unlock
fi


########################################################
# -----------------   GREETING   -------------------- #
########################################################

fastfetch
