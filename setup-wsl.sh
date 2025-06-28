#!/usr/bin/env bash

# Configure Ubuntu to use GCM from windows: for azure devops
[[ "$(uname -m)" == "aarch64" ]] && git_dir=clangarm64 || git_dir=mingw64
echo git config --global credential.helper "/mnt/c/Program\ Files/Git/$git_dir/bin/git-credential-manager.exe";
echo git config --global credential.useHttpPath true


# browser integration from WSL: so other azure services may use browser to do device login 
sudo add-apt-repository ppa:wslutilities/wslu
sudo apt update
sudo apt install wslu
