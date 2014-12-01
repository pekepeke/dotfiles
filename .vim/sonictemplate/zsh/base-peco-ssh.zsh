# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:
# {{_name_}}() {
  # local selected="$(ec2list --profile=$PROFILE | peco)"
  local selected="$(aws ec2 describe-instances --profile=$PROFILE | \
    jq -r '.Reservations[].Instances[] | select(.State.Name=="running") | {InstanceId, PublicIpAddress, PrivateIpAddress, InstanceName: (.Tags[] | select(.Key=="Name").Value), LaunchTime, AutoScaleGroup: (.Tags | map(select(.Key=="aws:autoscaling:groupName").Value))|join("")} | "\(.InstanceName) \(.PrivateIpAddress) \(.PublicIpAddress) \(.LaunchTime) \(.AutoScaleGroup)"' |\
    peco --query="$LBUFFER")"
  if [ -n "$selected" ]; then
    local ip=$(echo "$selected" | cut -f 3 -d' ')
    local name=$(echo "$selected" | cut -f 1 -d' ')
    if [ -n "$name" ]; then
      name="# $name"
    fi
    BUFFER="ssh $ip -l ec2-user -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no $name"
    zle accept-line
  fi
  zle -R
# }
# zle -N {{_name_}}


