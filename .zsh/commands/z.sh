
if [ -e ~/.zsh/plugins/z/z.sh ]; then
  _Z_CMD=j
  . ~/.zsh/plugins/z/z.sh
  precmd() {
    _z --add "$(pwd -P)"
  }
fi
