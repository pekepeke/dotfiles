# -*- mode: sh; coding: utf-8; -*-

if [ -f /etc/profile ]; then
  . /etc/profile
fi

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# prompt
[ -z "$PS1" ] && PS1='\u@\h[\w]\$ '
[ -z "$PS9" ] && PS9='\u@\h[\w]\$ '

LV='-Ia -Kej -Oej -Dej -Pej -c'

export BASH_ENV \
  PS1 PS9 \
  LV

# vim:fdm=marker sw=2 ts=2 ft=sh expandtab:

