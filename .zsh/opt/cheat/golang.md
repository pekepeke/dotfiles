Golang
======

### Cross Compile

```
GOOS=linux GOARCH=386 go build -o hoge_linux_386
GOOS=linux GOARCH=amd64 go build -o hoge_linux

GOOS=windows GOARCH=386 go build -o hoge_win_386
GOOS=windows GOARCH=amd64 go build -o hoge_win

GOOS=darwin GOARCH=386 go build -o hoge_darwin_386
GOOS=darwin GOARCH=amd64 go build -o hoge_darwin
```


| $GOOS     | $GOARCH  |
|-----------|----------|
| darwin    | 386      |
| darwin    | amd64    |
| darwin    | arm      |
| darwin    | arm64    |
| dragonfly | amd64    |
| freebsd   | 386      |
| freebsd   | amd64    |
| freebsd   | arm      |
| linux     | 386      |
| linux     | amd64    |
| linux     | arm      |
| linux     | arm64    |
| linux     | ppc64    |
| linux     | ppc64le  |
| linux     | mips64   |
| linux     | mips64le |
| netbsd    | 386      |
| netbsd    | amd64    |
| netbsd    | arm      |
| openbsd   | 386      |
| openbsd   | amd64    |
| openbsd   | arm      |
| plan9     | 386      |
| plan9     | amd64    |
| solaris   | amd64    |
| windows   | 386      |
| windows   | amd64    |

