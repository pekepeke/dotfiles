#!/bin/bash

# perl -e "exit 0 if `tmux -V | sed 's/^tmux\s*//'` $* ; exit 1;"
perl -e "my \$v = \`tmux -V\`; \$v =~ s/^tmux\\s*|\\D*\$//g; exit 0 if (\$v * 1) $*; exit 1"
exit $?
