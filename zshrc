DIR=${0:a:h}

# TG's custom
source $DIR/slurm-env.sh

#stty -ixon

export TERM=xterm-256color
alias emc="emacsclient -a ''"
alias emq="emacs -q -nw"
alias ls='ls --color=auto'

