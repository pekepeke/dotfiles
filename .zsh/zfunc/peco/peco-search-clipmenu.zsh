function peco-search-clipmenu() {
  cclip=`plutil -convert xml1 ~/Library/Application\ Support/ClipMenu/clips.data -o - | parsrx.sh | grep '/plist/dict/array/string ' | sed '1,2d' | sed 's/\/plist\/dict\/array\/string//g' | peco`

  if [ x"${cclip}" != x ]; then
    echo $cclip | pbcopy
  fi
}

zle -N peco-search-clipmenu
