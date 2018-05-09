#!/bin/sh

if git rev-parse --verify HEAD >/dev/null 2>&1 ; then
  AGAINST=HEAD
else
  # Initial commit: diff against an empty tree object
  AGAINST=$(git log --reverse | if read a commit ; then echo $commit ; fi)
fi

# Redirect output to stderr.
exec 1>&2
HAS_ERROR=0

# 特定ファイルのみ対象とする。
for FILE in `git diff-index --name-status $AGAINST -- | grep -E '^[AUM].*\.js$'| cut -c3-`; do
  # シンタックスのチェック
  if node --check $FILE; then
    js-beautify $FILE
    # if some-check-tool $FILE; then
    #   HAS_ERROR=1
    # fi
    git add $FILE
  else
    HAS_ERROR=1
  fi

done
exit $HAS_ERROR


