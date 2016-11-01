# dNitro.zsh-theme
# A Simple zsh theme based on robbyrussell's one with some additions include:
#   - Git actions: rebase, merge
#   - Vi mode indicator
#   - Cursor shape change based on vi mode
# ===========================================================================

autoload -Uz vcs_info

# Updates cursor shape based on vi mode
zle-keymap-select() {
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";
                    ;;  # block cursor
        main|viins) print -n -- "\E]50;CursorShape=1\C-G";
                    ;;  # line cursor
    esac
    zle reset-prompt
    zle -R
}
zle-line-finish() { print -n -- "\E]50;CursorShape=0\C-G" }
zle -N zle-keymap-select
zle -N zle-line-finish
zle -A zle-keymap-select zle-line-init

MODE_INDICATOR="%{$fg_bold[red]%}NORMAL%{$reset_color%}"

zstyle ':vcs_info:*' enable git
precmd() {
    vcs_info
}

setopt prompt_subst
zstyle ':vcs_info:*'    formats " "
zstyle ':vcs_info:*'    nvcsformats " "
zstyle ':vcs_info:*'    actionformats '%F{3} | %F{6}%a%f '

function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)${ref#refs/heads/}${vcs_info_msg_0_}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info) '
RPROMPT='$(vi_mode_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}[ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
# ============================================================================
