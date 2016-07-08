#
# zaw-cheat
#
# zaw source for cheat sheet view
#

[ x"$ZSH_ZAW_CHEAT" = x ] && ZSH_ZAW_CHEAT="$HOME/.zsh/opt/cheat"
function zaw-src-cheat() {
  candidates+=($(find "$ZSH_ZAW_CHEAT" -type f | sed "s|${ZSH_ZAW_CHEAT}/*||g"))
  actions=( "zaw-callback-cheat-autorender" "zaw-callback-cheat-pager" "zaw-callback-cheat-peco-yank" "zaw-callback-cheat-peco-input" "zaw-callback-cheat-cheat" "zaw-callback-cheat-yank" "zaw-callback-cheat-open" "zaw-callback-cheat-edit" "zaw-callback-cheat-cat" )
  act_descriptions=( "view(print or cat or pager)" "view" "yank with peco" "input with peco" "preview cheat" "yank cheat" "open" "edit" "cat")
}

function zaw-callback-cheat-cheat() {
  zle -M "`cat $ZSH_ZAW_CHEAT/$1`"
}

function zaw-callback-cheat-autorender() {
  local fname="$ZSH_ZAW_CHEAT/$1"
  local len=$(wc -l $fname | awk '{print $1}')
  local col=$(tput lines)
  local buf=$BUFFER
  if [ $len -ge $col ]; then
    [ -n "$buf" ] && zle push-line-or-edit
    zaw-callback-cheat-pager "$1"
  elif [ $len -le `expr $col / 2` ]; then
    zaw-callback-cheat-cheat "$1"
  else
    [ -n "$buf" ] && zle push-line-or-edit
    zaw-callback-cheat-cat "$1"
  fi
}

function zaw-callback-cheat-pager(){
  zle -M "`print "$PAGER : $ZSH_ZAW_CHEAT$1"`"
  BUFFER="$PAGER $ZSH_ZAW_CHEAT/$1"
  zle accept-line
}

function zaw-callback-cheat-yank() {
  local copy_cmd="xsel -b"
  type pbcopy >/dev/null && copy_cmd="pbcopy"
  type xclip >/dev/null && copy_cmd="xclip -i -selection clipboard"
  type pbcopy-wrapper >/dev/null && copy_cmd="pbcopy-wrapper"

  cat $ZSH_ZAW_CHEAT/$1 | eval $copy_cmd
  zle -M "`print "copy : $ZSH_ZAW_CHEAT$1"`"
}

function zaw-callback-cheat-peco-yank() {
  local copy_cmd="xsel -b"
  type pbcopy >/dev/null && copy_cmd="pbcopy"
  type xclip >/dev/null && copy_cmd="xclip -i -selection clipboard"
  type pbcopy-wrapper >/dev/null && copy_cmd="pbcopy-wrapper"

  zle -M "`print "peco(yank) : $ZSH_ZAW_CHEAT$1"`"
  zle -M "`cat $ZSH_ZAW_CHEAT/$1 | peco | eval $copy_cmd`"
}

function zaw-callback-cheat-peco-input() {
  zle -M "`print "peco(buffer) : $ZSH_ZAW_CHEAT$1"`"
  BUFFER=$(cat $ZSH_ZAW_CHEAT/$1 | peco)
  CURSOR=$#BUFFER
}

zaw-callback-cheat-open() {
  type open >/dev/null && BUFFER="open $ZSH_ZAW_CHEAT/$1"
  type xdg-open >/dev/null && BUFFER="xdg-open $ZSH_ZAW_CHEAT/$1"
  zle accept-line
}

zaw-callback-cheat-edit() {
  BUFFER="$EDITOR $ZSH_ZAW_CHEAT/$1"
  zle accept-line
}

zaw-callback-cheat-cat() {
  BUFFER="cat $ZSH_ZAW_CHEAT/$1"
  zle accept-line
}

zaw-register-src -n cheat zaw-src-cheat
