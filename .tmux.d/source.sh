#!/bin/bash

THOME=~/.tmux.d/
VER="$(tmux -V | cut -c 6- | sed 's/[^0-9]*$//g')"

if [[ $(echo "$VER <= 1.8" | bc) -eq 1 ]] ; then
  echo "1.8"
  tmux source-file "$THOME/v1.8.conf"
fi
if [[ $(echo "$VER == 1.9" | bc) -eq 1 ]] ; then
  echo "1.9"
  tmux source-file "$THOME/v1.9.conf"
fi
if [[ $(echo "$VER >= 2.1" | bc) -eq 1 ]] ; then
  echo "2.1"
  tmux source-file "$THOME/v2.1.conf"
fi
if [[ $(echo "$VER < 2.4" | bc) -eq 1 ]] ; then
  echo "2.4<"
  tmux source-file "$THOME/v2.4-before.conf"
fi
if [[ $(echo "$VER >= 2.4" | bc) -eq 1 ]] ; then
  echo "2.4>"
  tmux source-file "$THOME/v2.4.conf"
fi
