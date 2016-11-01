#!/usr/bin/env zsh
# File           : zsh-snippets
# Originated from: http://zshwiki.org/home/examples/zleiab
# Then           : 'willghatch' adds some handy interface functions, and
#                  packages it in a plugin (https://git.io/vXt0D) for easy
#                  use with plugin managers
# Now            : this version adds functionality to try completion if there
#                  is no snippet defined; this way you can do snippet
#                  expansion and completion with same key
#
# Use            : add-snippet <key> <expansion>
#                  Then, with cursor just past <key>, run snippet-expand
#                  Or hit <TAB> key ( change binding if you will )
# ============================================================================

typeset -Ag snippets

snippet-add() {
    # snippet-add <key> <expansion>
    snippets[$1]="$2"
}

expand-or-complete-with-dots() {
    echo -n "\e[31m...\e[0m"
    zle expand-or-complete-prefix
    zle redisplay
}
zle -N expand-or-complete-with-dots

expandSnippetOrComplete() {
  emulate -L zsh
  setopt extendedglob
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[.\-+:|_/a-zA-Z0-9]#}
  keys=${(@k)snippets}
  if (( ${keys[(I)$MATCH]} )); then
    LBUFFER+=${snippets[$MATCH]:-$MATCH}
    _zsh_highlight
    return
  else
    LBUFFER+=$MATCH
    zle expand-or-complete-with-dots
  fi
}
zle -N expandSnippetOrComplete

bindkey "^i" expandSnippetOrComplete

help-list-snippets(){
    local help="$(print "Add snippet:";
        print "snippet-add <key> <expansion>";
        print "Snippets:";
        print -a -C 2 ${(kv)snippets})"
    if [[ "$1" = "inZLE" ]]; then
        zle -M "$help"
    else
        echo "$help" | ${PAGER:-less}
    fi
}
run-help-list-snippets(){
    help-list-snippets inZLE
}
zle -N run-help-list-snippets

# set up some default snippets
snippet-add l      "less "
snippet-add tl     "| less "
snippet-add g      "grep "
snippet-add tg     "| grep "
snippet-add gl     "grep -l"
snippet-add tgl    "| grep -l"
snippet-add gL     "grep -L"
snippet-add tgL    "| grep -L"
snippet-add gv     "grep -v "
snippet-add tgv    "| grep -v "
snippet-add eg     "egrep "
snippet-add teg    "| egrep "
snippet-add fg     "fgrep "
snippet-add tfg    "| fgrep "
snippet-add fgv    "fgrep -v "
snippet-add tfgv   "| fgrep -v "
snippet-add ag     "agrep "
snippet-add tag    "| agrep "
snippet-add ta     "| ag "
snippet-add p      "${PAGER:-less} "
snippet-add tp     "| ${PAGER:-less} "
snippet-add h      "head "
snippet-add th     "| head "
snippet-add t      "tail "
snippet-add tt     "| tail "
snippet-add s      "sort "
snippet-add ts     "| sort "
snippet-add v      "${VISUAL:-${EDITOR:-nano}} "
snippet-add tv     "| ${VISUAL:-${EDITOR:-nano}} "
snippet-add tc     "| cut "
snippet-add tu     "| uniq "
snippet-add tx     "| xargs "
