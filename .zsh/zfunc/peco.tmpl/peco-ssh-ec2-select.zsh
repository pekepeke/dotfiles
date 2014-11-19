# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:
# peco-ssh-ec2-select() {
  local selected=$(ec2list --profile=$PROFILE | peco | cut -f 3)

  if [ -n "$selected" ]; then
    BUFFER="ssh $selected -l ec2-user -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no"
    zle accept-line
  fi
  zle -R
  # zle -R -c
# }
# zle -N peco-ssh-ec2-select

