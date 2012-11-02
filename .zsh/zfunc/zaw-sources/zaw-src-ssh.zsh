# for zaw.zsh https://github.com/zsh-users/zaw
# ref: https://github.com/zsh-users/zaw/blob/master/sources/git-files.zsh

function zaw-src-ssh() {
    if [[ $? == 0 ]]; then
        # candidates=(`cat ~/.ssh/known_hosts | ruby -ne 'puts $_.sub(/^(.*?)[ ,].*$/){$1}' | uniq`)
        candidates=(`grep -e '^Host' ~/.ssh/config | awk '{print $2;}'`)
        candidates+=(`perl -ne 'm/^(.*?)[ ,].*$/; print "$1\n"' ~/.ssh/known_hosts | uniq`)
    fi
    actions=("zaw-src-ssh-command" "zaw-callback-append-to-buffer")
    act_descriptions=("ssh" "append to edit buffer")
    options=("-m")
}

function zaw-src-ssh-command () {
    BUFFER="ssh $1"
    zle accept-line
}

zaw-register-src -n ssh zaw-src-ssh
