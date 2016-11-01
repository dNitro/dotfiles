# File : .zshrc
# By   : dNitro <ali.zarifkar AT gmail DOT com>
# =============================================

# Prompt to whether install zgen if it isn't installed
if [ ! -d ~/.zgen ]; then
    printf "Zgen isn't installed! Install? [y/N]: "
    if read -q; then
        echo; git clone https://github.com/tarjoilija/zgen.git ~/.zgen
    else
        printf "\n"
        exit 1
    fi
fi

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/bower
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/z
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load hlissner/zsh-autopair "autopair.zsh"
    zgen load ~/.zsh/plugin/zsh-snippets

    # theme
    zgen load ~/.zsh/theme/dNitro

    # save all to init script
    zgen save
fi

# Bind j and k keys for history search
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# kill the lag to change modes in commandline vi mode
export KEYTIMEOUT=1

# ENVs
export PATH="/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/X11/bin"
export EDITOR='vim'

# Aliases
source $HOME/.zsh/aliases
# =============================================
