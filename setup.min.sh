# this is for local setup without git clone
# assume dotfiles are already transferred 

set -e
log() { echo "$@" >&2 ; }

if [[ -e "${OSH}" ]]; then
  log "$OSH already sourced; skipping.." 
  exit 2
fi

DOTFS=~/.dotfiles
if [[ ! -d $DOTFS ]]; then
    log "$DOTFS does not exist. Please rerun";
    exit 2
fi

echo -e "\nsource $DOTFS/.bashrc\n" >> ~/.bashrc

for f in .tmux.conf .emacs.d; do 
    [[ -f $HOME/$f || -d $HOME/$f ]] && mv $HOME/$f{,.tg.bak}
    ln -s $DOTFS/$f $HOME/$f
done

# profile file, if missing
[[ -f ~/.bash_profile ]] || echo "[[ -f ~/.bashrc ]] && source ~/.bashrc" >> ~/.bash_profile

# store git
# git config --global credential.helper store

# htop rc
mkdir -p $HOME/.config/htop/
if [[ -e $HOME/.config/htop/htoprc ]]; then 
    rm -f $HOME/.config/htop/htoprc.bak
    mv $HOME/.config/htop/htoprc{,.bak}
fi
ln -s $DOTFS/htoprc $HOME/.config/htop/htoprc
