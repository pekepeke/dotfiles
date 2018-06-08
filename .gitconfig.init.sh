#!/bin/bash
# vim:fdm=marker sw=2 ts=2 ft=sh expandtab:

_print_config() {
  DIFFTOOL="vimdiff"
  MERGETOOL="vimfugitive"
  if [ -z "IF_GUI" ] ; then
    DIFFTOOL="gvimdiff"
    MERGETOOL="gvimfugitive"
    if [ -z "IF_OSX" ] ; then
      DIFFTOOL="mvimdiff"
      MERGETOOL="mvimfugitive"
    fi
  fi

  cat <<EOM
# vim:fdm=marker sw=2 ts=2 ft=gitconfig expandtab:
[include]
  path = ~/.gitconfig.d/core.txt
  ${IF_OSX}path = ~/.gitconfig.d/core.osx.txt
  ${IF_WIN}path = ~/.gitconfig.d/core.windows.txt
  path = ~/.gitconfig.d/alias.txt
  path = ~/.gitconfig.d/color.txt
  path = ~/.gitconfig.d/commit.txt
  path = ~/.gitconfig.d/pager.txt
  path = ~/.gitconfig.d/diff.txt
  path = ~/.gitconfig.d/diff.encoding.txt
  ${IF_OSX}path = ~/.gitconfig.d/diff.osx.txt
  path = ~/.gitconfig.d/diff.local.txt
  path = ~/.gitconfig.d/ghq.txt
  path = ~/.gitconfig.d/difftool.vim.txt
  ${IF_OSX}path = ~/.gitconfig.d/difftool.osx.txt
  ${IF_WIN}path = ~/.gitconfig.d/difftool.windows.txt
  path = ~/.gitconfig.d/difftool.local.txt
  path = ~/.gitconfig.d/interactive.txt
[user]
  name = hoge
  email = hoge+git@gmail.com
[push]
  default = simple
; default = tracking ; <=2.0
[pull]
  rebase = true
[diff]
  tool = ${DIFFTOOL}
  algorithm = histogram ; patience
  ; tool = vimdiff/gvimdiff/kdiff3/meld/diffmerge
[difftool]
  prompt = false
[merge]
  tool = ${MERGETOOL}
  ; tool = vimfugitive/gvimfugitive/mvimfugitive
  ; tool = kdiff3/meld/diffmerge
  ; ff = false
[mergetool]
  ; prompt = false
EOM
}

show_config() {
  IF_WIN="; "
  IF_OSX="; "
  IF_LINUX="; "
  IF_GUI="; "
  if type X >/dev/null 2>&1 && ps aux | grep `which X` >/dev/null 2>&1; then
    IF_GUI=""
  fi

  case $OSTYPE in
    cygwin*|msys*)
      IF_WIN="" ;;
    darwin*)
      IF_OSX="" ;;
    freebsd*)
      ;;
    linux*)
      IF_LINUX="" ;;
    solaris*)
      ;;
    *)
      ;;
  esac

  _print_config
}

[ ! -e ~/.gitconfig ] && show_config > ~/.gitconfig

[ "$1" = "-d" ] && show_config
