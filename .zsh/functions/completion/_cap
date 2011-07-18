_cap () {
    `cap -T | grep '^cap ' | sed 's/^cap //' | sed 's/ .*//' | sed 's/^/compadd /'`
}

compdef _cap cap
