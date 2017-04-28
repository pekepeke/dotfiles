#!/bin/bash

perl -e "exit 0 if `tmux -V | sed 's/^tmux\s*//'` $* ; exit 1;"
exit $?
