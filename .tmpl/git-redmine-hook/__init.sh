#!/bin/bash


curl https://github.com/bleis-tift/Git-Hooks/raw/master/install-on-client | sh

cat <<'EOM'
*** feature

- id/12 ブランチで作業してる場合、コミットメッセージの末尾にrefs 12を自動で付与する
- masterブランチへの直接的なコミットを拒否する

EOM

