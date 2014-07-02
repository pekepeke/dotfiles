function peco-snippets() {
    local SNIPPETS=$(grep -v "^#" ~/.snippets | peco --query "$LBUFFER" | pbcopy-wrapper )
    zle clear-screen
}

