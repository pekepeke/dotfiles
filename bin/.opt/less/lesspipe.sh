#!/bin/sh

trap 'exit 0' PIPE

fallback() {
  hexdump -C -- "$1"
}

if [ -d "$1" ]; then
  ls -alF -- "$1" 2>/dev/null
else
  case "$1" in
    *.zip)
      unzip -vl "$1" 2>/dev/null ;;
    *.rar)
      unrar lv "$1" 2>/dev/null ;;
    *.tar)
      tar -vtf "$1" 2>/dev/null ;;
    *.tar.gz|*.tgz|*.tar.z)
      tar -zvtf "$1" 2>/dev/null ;;
    *.tar.Z|*.tZ)
      tar -Zvtf "$1" 2>/dev/null ;;
    *.tar.bz2|*.tbz2|*.tbz)
      tar -jvtf "$1" 2>/dev/null ;;
    *.Z)
      uncompress -c "$1" 2>/dev/null ;;
    *.gz|*.z)
      gzip -dc "$1" 2>/dev/null ;;
    *.bz2)
      bzip2 -dc "$1" 2>/dev/null ;;
    *.dvi)
      dvi2tty "$1" 2>/dev/null || fallback "$1" ;;
    *.ps|*.pdf)
      ps2ascii "$1" 2>/dev/null || pstotext "$1" 2>/dev/null || pdftotext "$1" 2>/dev/null || fallback "$1" ;;
    *.doc)
      antiword "$1" 2>/dev/null || catdoc "$1" 2>/dev/null || fallback "$1" ;;
    *.rtf)
      unrtf --nopict --text "$1" || fallback "$1" ;;
    ftp://*|http://*|https://*|*.htm|*.html)
      for b in links2 links lynx w3m ; do
        ${b} -dump "$1" 2>/dev/null && exit 0
      done
      html2text -style pretty "$1" 2>/dev/null || curl -skL "$1"
      ;;
    *.rpm)
      rpm -qpivl --changelog -- "$1" ;;
    *.cpi|*.cpio)
      cpio -itv < "$1" ;;
    *.ace)
      unace l "$1" ;;
    *.arc)
      arc v "$1" ;;
    *.arj)
      unarj l -- "$1" ;;
    *.cab)
      cabextract -l -- "$1" ;;
    *.lha|*.lzh)
      lha v "$1" ;;
    *.zoo)
      zoo -list "$1" ;;
    *.7z)
      7z l -- "$1" ;;
    *.a)
      ar tv "$1" ;;
    *.so)
      readelf -h -d -s -- "$1" ;;
    *.mo|*.gmo)
      msgunfmt -- "$1" ;;
    *.deb|*.udeb)
      if type -p dpkg > /dev/null ; then
        dpkg --info "$1"
        dpkg --contents "$1"
      else
        ar tv "$1"
        ar p "$1" data.tar.gz | tar tzvvf -
      fi
      ;;
  esac
fi


