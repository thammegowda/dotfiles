# Dotfiles

A small Bash configuration for Linux and WSL.

## What is included

- A native Bash prompt with the current directory, active Python environment, and Git branch
- No shell framework or working-tree status scan in the prompt
- Personal aliases and Slurm helpers
- tmux and htop configuration
- Platform-specific Git Credential Manager setup

The prompt recognizes mamba environments through `CONDA_DEFAULT_ENV` and activated
`venv` or `uv` environments through `VIRTUAL_ENV`. Environment managers are intentionally
installed and initialized separately.

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/thammegowda/dotfiles/master/setup.bash)"
```

The installer is idempotent. On Ubuntu and Debian it installs missing bootstrap tools
and the latest Git Credential Manager, clones to `~/.dotfiles` when needed, adds one
guarded source line to `~/.bashrc`, and links the tmux and htop files. From an existing
clone, run:

```bash
./setup.bash
```

The prompt deliberately shows only the Git branch. It never runs `git status`, avoiding
long pauses in repositories stored on `/mnt/c` under WSL.

## Credentials

On headless Linux nodes, `setup.bash` configures Git Credential Manager for Azure and
GitHub browser OAuth with a 12-hour in-memory credential cache. Set
`GCM_CREDENTIAL_STORE` before setup to select a different supported store.

WSL uses Git Credential Manager from the Windows host instead:

```bash
# WSL, with Git for Windows already installed
./setup-wsl.sh

# macOS, with Homebrew already installed
./setup-mac.sh
```

