function peco-select-snippets() {
    local SNIPPETS=$(grep -v "^#" ~/.snippets | peco --query "$LBUFFER" | pbcopy-wrapper )
    zle clear-screen
}
zle -N peco-select-snippets
