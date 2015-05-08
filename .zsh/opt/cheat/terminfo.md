```bash
cat <<EOM > screen-256color.terminfo
screen-256color|GNU Screen with 256 colors,
       use=xterm-256color,
EOM
tic screen-256color.terminfo
```

