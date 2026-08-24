[[ $- == *i* ]] || return
[[ -n ${TG_DOTFILES_LOADED:-} ]] && return
TG_DOTFILES_LOADED=1

DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$PATH"
export CONDA_CHANGEPS1=false

shopt -s extglob histappend progcomp
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000

source "$DOTFILES_DIR/slurm-env.sh"

alias emc="emacsclient -a ''"
alias emq='emacs -q -nw'
alias ls='ls --color=auto'
alias ll='ls -l'
alias realpwd='realpath "$PWD"'
alias awkt="awk -F '\t' -v OFS='\t'"

lowercase() {
  awk '{ print tolower($0) }'
}

[[ -t 0 ]] && stty -ixon

__tg_git_ref() {
  TG_GIT_REF=
  command -v git &>/dev/null || return
  TG_GIT_REF=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
    TG_GIT_REF=$(command git rev-parse --short HEAD 2>/dev/null) ||
    TG_GIT_REF=
}

__tg_prompt() {
  local environment_name=${CONDA_DEFAULT_ENV:-}
  local environment_prompt= git_prompt=

  if [[ -z $environment_name && -n ${VIRTUAL_ENV:-} ]]; then
    environment_name=${VIRTUAL_ENV%/}
    environment_name=${environment_name##*/}
  fi
  [[ -n $environment_name ]] && environment_prompt=" \[\e[35m\]($environment_name)\[\e[0m\]"

  __tg_git_ref
  [[ -n $TG_GIT_REF ]] && git_prompt=" \[\e[36m\][$TG_GIT_REF]\[\e[0m\]"

  PS1="\n\[\e[32m\]\u\[\e[0m\]@\[\e[33m\]\h\[\e[0m\] \[\e[34m\]\w\[\e[0m\]${environment_prompt}${git_prompt}\n\\$ "
}

if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) != 'declare -a'* ]]; then
  _tg_existing_prompt_command=${PROMPT_COMMAND:-}
  PROMPT_COMMAND=()
  [[ -n $_tg_existing_prompt_command ]] && PROMPT_COMMAND+=("$_tg_existing_prompt_command")
  unset _tg_existing_prompt_command
fi
PROMPT_COMMAND+=(__tg_prompt)
unset DOTFILES_DIR
