
# (( $+functions[$_Z_CMD] )) || return

zaw-src-keybind() {
  # <rank><space><dir> の組でくるので、そこからdirだけ抜き取る
  #: ${(A)candidates::=${${(f)"$($_Z_CMD -l | sort -n -r)"}##<->(.<->)# ##}}
  candidates=(`bindkey|sed 's/ /:/g'`)
  actions=(zaw-src-keybind-empty)
  act_descriptions=("empty")
}

zaw-src-keybind-empty() {
  # echo $1 | cut -d' ' -f1
}

zaw-register-src -n keybind zaw-src-keybind
