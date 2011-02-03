#!/bin/bash

pushd .

operation=pull
case $1 in
    "")
        ;;
    pull|status)
        operation=$1;;
    *)
        exit 1;;
esac
for FILE in $(ls $HOME/.vim/bundle) ; do
    cd "$HOME/.vim/bundle/$FILE"

    if [ -d .git ]; then
        echo -n processing [$FILE]\\t\\t
        git $operation
    else
        echo skip file [$FILE]
    fi
done

popd

