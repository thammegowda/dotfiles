#!/usr/bin/env bash

set -e

log() {
    echo "$@" >&2
}

DOTFILES=~/.dotfiles
if [[ -d $DOTFILES ]]; then
    log "$DOTFS already exists. skipping";
    exit 2
fi

git clone https://github.com/thammegowda/dotfiles.git --depth 1 $DOTFILES

echo "source $DOTFILES/.bashrc" >> ~/.bashrc
