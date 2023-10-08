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
    zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/z
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
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
export PATH="/usr/local/mongodb/bin:/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/X11/bin"
export EDITOR='vim'

# Load TMUX and attach to base session on zsh initiation
if [ -z "$TMUX" ]; then
    tmux attach -t base || tmux new -s base
fi

# Aliases
source $HOME/.zsh/aliases
# =============================================
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# =============================================
# Android SDK
export ANDROID_HOME=/usr/local/share/android-sdk
export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
export ANDROID_AVD_HOME=$HOME/.android/avd
alias emu="$ANDROID_HOME/emulator/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
# =============================================
# python
export PATH="$PATH:/Users/david/Library/Python/3.7/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
