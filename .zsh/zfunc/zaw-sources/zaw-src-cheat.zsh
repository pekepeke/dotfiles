#
# zaw-cheat
#
# zaw source for cheat sheet view
#

function zaw-src-cheat() {
  local root="$HOME/.zsh/cheat/"
  candidates+=($(find "$root" -type f | sed "s@$root@@g"))
  actions=( "zaw-callback-cheat")
  act_descriptions=( "preview cheat")
}

function zaw-callback-cheat() {
  local root="$HOME/.zsh/cheat/"
  zle -M "`cat $root/$1`"
}

zaw-register-src -n cheat zaw-src-cheat
