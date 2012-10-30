# https://gist.github.com/3070804
# (( $+functions[$_Z_CMD] )) || return

zaw-src-z() {
  # <rank><space><dir> の組でくるので、そこからdirだけ抜き取る
  #: ${(A)candidates::=${${(f)"$($_Z_CMD -l | sort -n -r)"}##<->(.<->)# ##}}
  candidates=(`cat ~/.z | cut -d'|' -f1`)
  actions=(zaw-src-z-cd)
  act_descriptions=("cd")
}

zaw-src-z-cd() {
  BUFFER="cd $1"
  zle accept-line
}

zaw-register-src -n z zaw-src-z
