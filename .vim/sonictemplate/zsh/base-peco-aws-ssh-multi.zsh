# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:
# {{_name_}}() {
  # local selected="$(ec2list --profile=$PROFILE | peco)"
  local selected="$(aws ec2 describe-instances --profile=$PROFILE | \
    jq -r '.Reservations[].Instances[] | select(.State.Name=="running") | {InstanceId, PublicIpAddress, PrivateIpAddress, InstanceName: (.Tags[] | select(.Key=="Name").Value), LaunchTime, AutoScaleGroup: (.Tags | map(select(.Key=="aws:autoscaling:groupName").Value))|join("")} | "\(.InstanceName)    \(.PrivateIpAddress)    \(.PublicIpAddress)    \(.LaunchTime)    \(.AutoScaleGroup)"' |\
    peco --query="$LBUFFER" | \
    awk '{print $3}')"
  if [ -n "$selected" ]; then
    BUFFER="multi_ssh $(echo ${selected}) --option=\"-l ec2-user -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\""
    zle accept-line
  fi
  zle -R
# }
# zle -N {{_name_}}



