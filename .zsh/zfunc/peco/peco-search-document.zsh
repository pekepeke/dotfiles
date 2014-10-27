function peco-search-document() {
  local DOCUMENT_DIR
  DOCUMENT_DIR=($HOME/Dropbox)
  if [ -d $HOME/Documents ]; then
    DOCUMENT_DIR=($HOME/Documents $DOCUMENT_DIR)
  fi
  local SELECTED_FILE=$(echo $DOCUMENT_DIR | \
    xargs find | \
    grep -E "\.(txt|md|pdf|key|numbers|pages|docx?|xlsx?|pptx?)$" | \
    peco --query="$LBUFFER")
  if [ x"$SELECTED_FILE" != x ]; then
    BUFFER=$(echo $SELECTED_FILE | sed 's/ /\\ /g')
  fi
}
zle -N peco-search-document
