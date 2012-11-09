# zaw.zsh source for 'git show-branch'.
# Thank you very much, nakamuray!
# https://github.com/nakamuray/zaw

zaw-src-git-showbranch () {
  git rev-parse -q --is-inside-work-tree >/dev/null || return 1

  #local b="${orig_lbuffer}${orig_rbuffer}"
  local b="$BUFFER"
  local z="$(git rev-parse --git-dir)""/zaw-src-git-showbranch"

  {
    zaw-src-git-showbranch~ "$b" "$z" >| ${z}.tmp
  } always {
    mv -f ${z}.tmp ${z}
  }
  : ${(A)candidates::=${(@f)"$(<"${z}")"}}; shift candidates
  actions=("zaw-callback-git-showbranch")
  act_descriptions=("setup edit buffer")
}

zaw-src-git-showbranch~ () {
  local gb="$1"
  local zf="$2"
  [[ "$gb" == 'git show-branch '* ]] && { echo "$gb"; "${(z)gb}" ; return $? }
  [[ -s "$zf" ]] && { "$0" "$(head -n1 $zf)" "$zf"; return $? }
  return -1
}

zaw-callback-git-showbranch () {
  setopt localoptions extendedglob
  zaw-callback-git-showbranch-loop "$1" "" zaw-callback-git-showbranch~
}

zaw-callback-git-showbranch-loop () {
  local buf="$1"
  local mat="$2"
  local fun="$3"
  local -a match mbegin mend
  [[ "$buf" == (#b)(*)\[(*)\]* ]] &&
    { "$0" "$match[1]" "$match[2]" "$fun" ; return $? }
  [[ -n "$mat" ]] && { "$fun" "$mat"; return $? }
  return -1
}

zaw-callback-git-showbranch~ () {
  BUFFER="noglob zargs $1 -- git "
  ((CURSOR=$#BUFFER))
}

zaw-register-src -n git-showbranch zaw-src-git-showbranch

#print -z 'git show-branch master next pu'
#zaw-src-git-showbranch~ "" .git/zaw-src-git-showbranch ; echo $?

