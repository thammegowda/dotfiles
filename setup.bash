#!/usr/bin/env bash

set -e

log() { echo "$@" >&2 ; }

DOTFS=~/.dotfiles
if [[ -d $DOTFS ]]; then
    log "$DOTFS already exists. skipping";
    exit 2
fi

git clone https://github.com/thammegowda/dotfiles.git --depth 1 $DOTFS

echo "source $DOTFS/.bashrc" >> ~/.bashrc

for f in .tmux.conf .emacs.d; do 
    [[ -f $HOME/$f || -d $HOME/$f ]] && mv $HOME/$f{,.tg.bak}
    ln -s $DOTFS/$f $HOME/$f
done


which conda || {
  log "Installing miniconda3..."
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O conda-setup.sh \
  && bash conda-setup.sh -b -p ~/miniconda3 \
  && ~/miniconda3/bin/conda init bash \
  && rm conda-setup.sh
}

log "Installation done. Open new shell to initialize new environment"
