#!/usr/bin/env bash

set -euo pipefail

manager=
for candidate in \
	'/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe' \
	'/mnt/c/Program Files/Git/clangarm64/bin/git-credential-manager.exe'
do
	if [[ -f $candidate ]]; then
		manager=$candidate
		break
	fi
done

if [[ -z $manager ]]; then
	printf '%s\n' 'Git Credential Manager was not found. Install Git for Windows first.' >&2
	exit 1
fi

git config --global credential.helper "${manager// /\\ }"
git config --global credential.useHttpPath true
git config --global credential.githubAuthModes browser
git config --global init.defaultBranch main

printf 'WSL now uses %s\n' "$manager"
