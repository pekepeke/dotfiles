#!/bin/sh

# perl -e "exit 0 if `tmux -V | sed 's/^tmux\s*//'` $* ; exit 1;"
# perl -e "my \$v = \`tmux -V\`; \$v =~ s/^tmux\\s*|\\D*\$//g; exit 0 if (\$v * 1) $*; exit 1"
# echo perl -e "my \$v = \`tmux -V\`; \$v =~ s/^tmux\\s*|\\D*\$//g; exit 0 if (\$v * 1) $*; exit 1"
# perl -Mversion -e "my \$v = \`tmux -V\`; \$v =~ s/^tmux\\s*|\\D*\$//g;print \$v.\"\n\";  exit 0 if version->declare(\$v)->numify $1 version->declare(\"$2\")->numify; exit 1"
# print \$v.\"\n\";
perl -Mversion -e "my \$v = \`tmux -V\`; \$v =~ s/^tmux\\s*|\\D*\$//g; exit 0 if version->declare(\$v)->numify $1 version->declare(\"$2\")->numify; exit 1"
# perl -Mversion -e 'my $v = `tmux -V`; $v =~ s/^tmux\s*|\s*$//g; '
# perl -e 'my $v = `tmux -V`; $v =~ s/^tmux\\s*|\\D*\$//g; exit 0 if (\$v * 1) $*; exit 1'
exit $?
