# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:
# peco-ssh-ec2-select() {
  local selected="$(ec2list --profile=$PROFILE | peco)"

  if [ -n "$selected" ]; then
    local ip=$(echo "$selected" | cut -f 3)
    local name=$(echo "$selected" | cut -f 1)
    if [ -n "$name" ]; then
      name="# $name"
    fi
    BUFFER="ssh $ip -l ec2-user -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no $name"
    zle accept-line
  fi
  zle -R
  # zle -R -c
# }
# zle -N peco-ssh-ec2-select

