# zaw source for git files

function zaw-src-git-dirtyfiles() {
  # XXX : FIXME
  candidates=($(git status --short | perl -ne 'printf("%-50s     [%s]\n", $2, $1) if /^\s*([MADRCU!\?]+) (.*)$/'))
  actions=("zaw-callback-append-to-buffer" "zaw-callback-edit-file" "zaw-src-git-dirtyfiles-add")
  act_descriptions=("add" "append to edit buffer" "add file")
  return 0
}

function zaw-src-git-dirtyfiles-add () {
  BUFFER="git add $1"
  zle accept-line
}

zaw-register-src -n git-dirtyfiles zaw-src-git-dirtyfiles
