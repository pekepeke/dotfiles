#compdef loga
# Version: 1.0.1
# Author: Takahiro YOSHIHARA <tacahiroy\AT/gmail.com>
# supported logaling-command-0.2.0
#
# License: The MIT License
# Copyright 2012 Takahiro YOSHIHARA # {{{
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# The software is provided "as is", without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. In no event shall the
# authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising from,
# out of or in connection with the software or the use or other dealings in the
# software.
# }}}

_loga_config_keys() {
  keys=(glossary source-language target-language)
  compadd $@ -k keys
}

_loga_source_terms() {
  # trim TARGET TERM and NOTE
  # By default, sed doesn't support '\t' and '\x09' on OS X :(
  terms=(${(f)"$(loga show --no-pager | sed -e 's/^[ ]\{1,\}//;s/[ ]*	[^ ].*$//;s/^[ ]*//')"})
  compadd $@ -k terms
}

_loga_target_terms() {
  src=$(print $words[2] | sed -e 's/"//g')
  if [[ "${src}" != "" ]]; then
    # FIXME: complicated!
    target_terms=(${(f)"$(loga lookup "${src}" --no-pager --no-color --output=json | \
                  grep -C1 "^  \"source\": \"${src}\"," | grep '"target":' | \
                  sed -e 's/[ \"]//g;s/,$//' | awk -F: '{print $2}')"})
    compadd $@ -k target_terms
  fi
}

_loga_glossaries() {
  glossaries=(`loga list --no-pager | tr -d ' '`)
  compadd $@ -k glossaries
}

# this can be worked for 'loga copy' only
_loga_source_language() {
  glossary=$words[2]
  lang=(${(f)"$(fgrep -e '--source-language' $HOME/.logaling.d/projects/${glossary}/config | grep -o '[^ ]\+$')"})
  compadd $@ -k lang
}

# this can be worked for 'loga copy' only
_loga_target_language() {
  glossary=$words[2]
  lang=(${(f)"$(fgrep -e '--target-language' $HOME/.logaling.d/projects/${glossary}/config | grep -o '[^ ]\+$')"})
  compadd $@ -k lang
}

_loga_output_type() {
  types=(csv json)
  compadd $@ -k types
}

_loga_importable_projects() {
  projects=(${(f)"$(loga import --list | sed -e 's/[ ]\{1,\}:.*$//')"})
  compadd $@ -k projects
}

_loga_tasks() {
  _tasks=(
    "add"
    "config"
    "copy"
    "delete"
    "help"
    "import"
    "list"
    "lookup"
    "new"
    "register"
    "show"
    "unregister"
    "update"
    "version")
  compadd "$@" -k _tasks
}

local -a _tasks
_tasks=(
  "add:Add term to glossary"
  "config:Set config"
  "copy:Copy personal glossary"
  "delete:Delete term"
  "help:Describe available tasks or one specific task"
  "import:Import external glossary"
  "list:Show glossary list"
  "lookup:Lookup terms"
  "new:Create .logaling"
  "register:Register .logaling"
  "show:Show terms in glossary"
  "unregister:Unregister .logaling"
  "update:Update term"
  "version:Show version")

# local -a terms glossaries is_project_dir

#"--output=-[output type]:types:->output_type" \
_loga_global_flags=(
  "(-g --glossary=-)"{-g,--glossary=}"[glossary name]:glossaries:->glossary"
  "(-S --source-language=-)"{-S,--source-language=}"[source language(e.g. en)]"
  "(-T --target-language=-)"{-T,--target-language=}"[target language(e.g. ja)]"
  "(-h --logaling-home=-)"{-h,--logaling-home=}"[logaling home]:directory:_directories"
  "(-c --logaling-config=-)"{-c,--logaling-config=}"[.logaling directory]:directory:_directories"
)

_arguments \
  "*:: :->subcmds" && return 0

if (( CURRENT == 1 )); then
  _describe -t commands "loga subcommand" _tasks
  return
fi

case "$words[1]" in
  add|new|unregister)
    _arguments \
      $_loga_global_flags
    ;;
  import)
    _arguments \
      ":projects:_loga_importable_projects" \
      "--list" \
      $_loga_global_flags
    ;;
  config)
    _arguments \
      ":key:_loga_config_keys" \
      ":value:" \
      "--global" \
      $_loga_global_flags
    ;;
  copy)
    _arguments \
      ":glossary:_loga_glossaries" \
      ":source-language:_loga_source_language" \
      ":target-language:_loga_target_language" \
      ":new-glossary-name:" \
      ":new-source-language:" \
      ":new-target-language:" \
      $_loga_global_flags
    ;;
  delete)
    _arguments \
      ":source:_loga_source_terms" \
      ":target:_loga_target_terms" \
      "--force" \
      $_loga_global_flags
    ;;
  lookup)
    _arguments \
      ":source:_loga_source_terms" \
      "--no-pager" \
      "--no-color" \
      "--dict" \
      "--fixed" \
      "--output=-[output type]:types:->output_type" \
      $_loga_global_flags
    ;;
  update)
    _arguments \
      ":source:_loga_source_terms" \
      ":target:_loga_target_terms" \
      ":new_target:_loga_target_terms" \
      $_loga_global_flags
    ;;
  show)
    _arguments \
      "--no-pager" \
      "(-A --annotation)"{-A,--annotation}"[search incomplete terms]" \
      $_loga_global_flags
    ;;
  list)
    _arguments \
      "--no-pager" \
      $_loga_global_flags
    ;;
  help)
    _arguments \
      ":task:_loga_tasks"
    ;;
esac

case "$state" in
  glossary)
    _loga_glossaries
    ;;
  output_type)
    _loga_output_type
    ;;
esac

# vim: fen:fdm=marker

