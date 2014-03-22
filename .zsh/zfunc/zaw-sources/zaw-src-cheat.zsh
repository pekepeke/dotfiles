#
# zaw-cheat
#
# zaw source for cheat sheet view
#

[ x"$ZSH_ZAW_CHEAT" = x ] && ZSH_ZAW_CHEAT="$HOME/.zsh/cheat/"
function zaw-src-cheat() {
  candidates+=($(find "$ZSH_ZAW_CHEAT" -type f | sed "s|${ZSH_ZAW_CHEAT}/*||g"))
  actions=( "zaw-callback-cheat-cheat" "zaw-callback-cheat-yank" "zaw-callback-cheat-open" "zaw-callback-cheat-cat")
  act_descriptions=( "preview cheat" "yank cheat" "open" "cat")
}

function zaw-callback-cheat-cheat() {
  zle -M "`cat $ZSH_ZAW_CHEAT/$1`"
}

function zaw-callback-cheat-yank() {
  local copy_cmd="xsel -b"
  type pbcopy >/dev/null && copy_cmd="pbcopy"
  type xclip >/dev/null && copy_cmd="xclip -i -selection clipboard"

  cat $ZSH_ZAW_CHEAT/$1 | eval $copy_cmd
  zle -M "`print "copy : $ZSH_ZAW_CHEAT$1"`"
}

zaw-callback-cheat-open() {
  BUFFER="xdg-open $ZSH_ZAW_CHEAT/$1"
  zle accept-line
}

zaw-callback-cheat-cat() {
  BUFFER="cat $ZSH_ZAW_CHEAT/$1"
  zle accept-line
}

zaw-register-src -n cheat zaw-src-cheat
