#!/bin/bash

show_notification() {
  cat <<'EOM'
## add following codes to source/conf.py

------------------------------
sys.path += ["."]
extensions += ["markdown"]

markdown_title = 'hello world'
source_suffix = '.md'
------------------------------
EOM
}


if [ ! -e Makefile ]; then
  echo "Makefile is not found" 1>&2
fi

if [ ! -e sphinxcontrib_markdown.py ]; then
  wget https://gist.github.com/raw/4336929/25dfcaad2b2d63a973617757062cec3ab9c31c35/sphinxcontrib_markdown.py
  show_notification
fi
