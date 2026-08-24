#!/usr/bin/env bash

# Minimal macOS setup: Git Credential Manager only.
# macOS remains a client device and does not install the Bash dotfiles.
# Ref: https://github.com/git-ecosystem/git-credential-manager

set -euo pipefail

# Homebrew is required
command -v brew >/dev/null || {
    echo "Homebrew not found. Install it first: https://brew.sh" >&2
    exit 1
}

command -v git-credential-manager >/dev/null || brew install --cask git-credential-manager

git-credential-manager configure
git config --global credential.credentialStore keychain
git config --global credential.msauthFlow system
git config --global credential.azreposCredentialType oauth
git config --global credential.githubAuthModes browser
git config --global init.defaultBranch main

echo "GCM setup done."
