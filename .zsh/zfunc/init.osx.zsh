function search-clipmenu() {
  local clip_menu_path="$HOME/Library/Application Support/ClipMenu"

  plutil -convert xml1 "$clip_menu_path/clips.data" -o - |\
    awk '/<string>/,/<\/string>/' |\
    sed -n '15, $p' |\
    sed -e 's/<string>//g' -e 's/<\/string>//g' -e 's/&lt;/</g' -e 's/&gt;/>/g' |\
    sed '/^$/d'|cat -n |sort -k 2|uniq -f1 |sort -k 1 |\
    sed -e 's/^ *[0-9]*//g' |\
    awk '{for(i=1;i<NF;i++){printf("%s%s",$i,OFS=" ")}print $NF}' |\
    nl -b t -n ln |percol |sed -e "s/\ /\\\ /g" |\
    sed -e 's/\\ / /g' |cut -c 8- |ruby -pe 'chomp' |pbcopy
  zle reset-prompt
}
zle -N search-clipmenu

