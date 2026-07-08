#!/usr/bin/env bash

# Minimal macOS setup: just Git Credential Manager (GCM).
# No bashrc / oh-my-bash / dotfile symlinks here -- macOS is a client device.
# Ref: https://github.com/git-ecosystem/git-credential-manager

set -eux

# Homebrew is required
command -v brew >/dev/null || {
    echo "Homebrew not found. Install it first: https://brew.sh" >&2
    exit 1
}

# install git-credential-manager if necessary
command -v git-credential-manager >/dev/null || brew install --cask git-credential-manager

git-credential-manager configure
# macOS: store credentials in the login keychain (default, but set explicitly)
git config --global credential.credentialStore keychain
# for azure devops: use browser-based OAuth (not device code)
git config --global credential.msauthFlow system
git config --global credential.azreposCredentialType oauth
# for github
git config --global credential.githubAuthModes browser
git config --global init.defaultBranch main

echo "GCM setup done."
