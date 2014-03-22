#
# zaw-stat
#
# zaw source for stat sheet view
#

[ x"$ZSH_ZAW_STAT" = x ] && ZSH_ZAW_STAT="$HOME/.zsh/stat/"
function zaw-src-stat() {
  candidates+=($(find "$ZSH_ZAW_STAT" -type f | sed "s|${ZSH_ZAW_STAT}/*||g"))
  actions=( "zaw-callback-stat-stat" "zaw-callback-stat-yank" "zaw-callback-stat-open" "zaw-callback-stat-exec")
  act_descriptions=( "preview stat" "yank stat" "open" "exec")
}

function zaw-callback-stat-stat() {
  zle -M "`$ZSH_ZAW_STAT/$1`"
}

function zaw-callback-stat-yank() {
  local copy_cmd="xsel -b"
  type pbcopy >/dev/null && copy_cmd="pbcopy"
  type xclip >/dev/null && copy_cmd="xclip -i -selection clipboard"

  $ZSH_ZAW_STAT/$1 | eval $copy_cmd
  zle -M "`print "copy : $ZSH_ZAW_STAT$1"`"
}

zaw-callback-stat-open() {
  BUFFER="xdg-open $ZSH_ZAW_STAT/$1"
  zle accept-line
}

zaw-callback-stat-exec() {
  BUFFER="$ZSH_ZAW_STAT/$1"
  zle accept-line
}

zaw-register-src -n stat zaw-src-stat
