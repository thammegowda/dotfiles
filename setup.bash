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

# profile file, if missing
[[ -f ~/.bash_profile ]] || echo "[[ -f ~/.bashrc ]] && source ~/.bashrc" >> ~/.bash_profile

# disabled; #TODO: pass CLI arg as --conda
[[ 1 -eq 1 ]] || {
    which mamba || {
      log "Installing mamba..."
      name=Miniforge3-$(uname)-$(uname -m).sh
      wget "https://github.com/conda-forge/miniforge/releases/latest/download/$name" \
        && bash $name -b -p ~/mambaforge && ~/mambaforge/bin/mamba init bash \
        && rm $name
    }
}

# store git
git config --global credential.helper store

# htop rc
mkdir -p $HOME/.config/htop/
if [[ -e $HOME/.config/htop/htoprc ]]; then 
    rm -f $HOME/.config/htop/htoprc.bak
    mv $HOME/.config/htop/htoprc{,.bak}
fi
ln -s $DOTFS/htoprc $HOME/.config/htop/htoprc


log "Installation done. Open new shell to initialize new environment"
