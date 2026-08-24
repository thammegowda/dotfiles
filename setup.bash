#!/usr/bin/env bash

set -euo pipefail

readonly REPO_URL=https://github.com/thammegowda/dotfiles.git
readonly GCM_RELEASE_API=https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest

log() {
    printf '%s\n' "$*" >&2
}

as_root() {
    if ((EUID == 0)); then
        "$@"
    elif command -v sudo >/dev/null; then
        sudo "$@"
    else
        log "Root access is required to install packages; install sudo or run as root"
        return 1
    fi
}

is_wsl() {
    [[ -n ${WSL_DISTRO_NAME:-} ]] || [[ -r /proc/version && $(</proc/version) == *[Mm]icrosoft* ]]
}

install_ubuntu_dependencies() {
    local -a packages=()

    [[ -r /etc/os-release ]] || return
    . /etc/os-release
    [[ ${ID:-} == ubuntu || ${ID:-} == debian ]] || return

    command -v git >/dev/null || packages+=(git)
    command -v curl >/dev/null || packages+=(curl)
    [[ -r /etc/ssl/certs/ca-certificates.crt ]] || packages+=(ca-certificates)
    if ! is_wsl; then
        command -v xdg-open >/dev/null || packages+=(xdg-utils)
        if ! command -v git-credential-manager >/dev/null; then
            command -v jq >/dev/null || packages+=(jq)
        fi
    fi

    ((${#packages[@]} == 0)) && return
    log "Installing Ubuntu dependencies: ${packages[*]}"
    as_root env DEBIAN_FRONTEND=noninteractive apt-get update
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${packages[@]}"
}

gcm_runtime() {
    case $(uname -m) in
    x86_64 | amd64) printf '%s\n' x64 ;;
    aarch64 | arm64) printf '%s\n' arm64 ;;
    *)
        log "Git Credential Manager does not provide a Debian package for $(uname -m)"
        return 1
        ;;
    esac
}

latest_gcm_deb_url() {
    local runtime=$1

    curl -fsSL "$GCM_RELEASE_API" | jq -er --arg prefix "gcm-linux-$runtime-" '
        .assets
        | map(select(.name | startswith($prefix)) | select(.name | endswith(".deb")))
        | first.browser_download_url
    '
}

install_gcm() {
    command -v git-credential-manager >/dev/null && return
    command -v apt-get >/dev/null || {
        log "Automatic Git Credential Manager installation requires Ubuntu or Debian"
        return 1
    }

    local runtime package_url package_file
    runtime=$(gcm_runtime)
    package_url=$(latest_gcm_deb_url "$runtime")
    package_file=$(mktemp --suffix=.deb)

    log "Installing Git Credential Manager from $package_url"
    if ! curl -fL "$package_url" -o "$package_file"; then
        rm -f "$package_file"
        return 1
    fi
    if ! as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "$package_file"; then
        rm -f "$package_file"
        return 1
    fi
    rm -f "$package_file"
}

configure_linux_gcm() {
    git-credential-manager configure
    git config --global credential.credentialStore "${GCM_CREDENTIAL_STORE:-cache}"
    git config --global credential.cacheOptions '--timeout 43200'
    git config --global credential.msauthFlow system
    git config --global credential.azreposCredentialType oauth
    git config --global credential.githubAuthModes browser
}

ensure_line() {
    local line=$1
    local file=$2

    touch "$file"
    grep -Fqx -- "$line" "$file" || printf '\n%s\n' "$line" >> "$file"
}

link_file() {
    local source=$1
    local destination=$2
    local backup

    if [[ -L $destination && $(readlink "$destination") == "$source" ]]; then
        return
    fi
    if [[ -e $destination || -L $destination ]]; then
        backup="${destination}.bak.$(date +%Y%m%d%H%M%S)"
        log "Moving $destination to $backup"
        mv "$destination" "$backup"
    fi
    mkdir -p "$(dirname "$destination")"
    ln -s "$source" "$destination"
}

main() {
    local dotfiles_dir=${DOTFILES_DIR:-$HOME/.dotfiles}
    local script_dir source_line

    install_ubuntu_dependencies
    command -v git >/dev/null || {
        log "Git is required; automatic package installation supports Ubuntu and Debian"
        return 1
    }

    if [[ -n ${BASH_SOURCE[0]:-} && -f ${BASH_SOURCE[0]} ]]; then
        script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
        [[ -d $script_dir/.git ]] && dotfiles_dir=$script_dir
    fi

    if [[ ! -d $dotfiles_dir/.git ]]; then
        if [[ -e $dotfiles_dir ]]; then
            log "$dotfiles_dir exists but is not a Git clone"
            return 1
        fi
        git clone --depth 1 "$REPO_URL" "$dotfiles_dir"
    fi

    if is_wsl; then
        bash "$dotfiles_dir/setup-wsl.sh"
    else
        install_gcm
        configure_linux_gcm
    fi

    source_line="[[ -r \"$dotfiles_dir/.bashrc\" ]] && source \"$dotfiles_dir/.bashrc\""
    ensure_line "$source_line" "$HOME/.bashrc"

    git config --global init.defaultBranch main
    git config --global core.excludesfile "$dotfiles_dir/.gitignore_global"

    link_file "$dotfiles_dir/.tmux.conf" "$HOME/.tmux.conf"
    link_file "$dotfiles_dir/htoprc" "$HOME/.config/htop/htoprc"

    log "Installation complete. Open a new shell to load the configuration."
}

if [[ -z ${BASH_SOURCE[0]:-} || ${BASH_SOURCE[0]} == "$0" ]]; then
    main "$@"
fi
