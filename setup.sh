#!/usr/bin/env bash

DIR="$(dirname $(realpath $0))"
echo $DIR


# TODO: bashrc
# TODO: zshrc

printf "
1. add  to ~/.bashrc
    source $DIR/.bashrc

2. add  to ~/.zshrc
    source $DIR/zshrc

3. setup emacs
  ln -s $DIR/.emacs.d ~/.emacs.d

4. setup tmux

  ln -s $DIR/.tmux.conf ~/.tmux.conf
"
