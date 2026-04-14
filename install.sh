#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STOW_PACKAGES=(zsh git helix kitty zellij btop claude)

info()  { echo -e "\033[1;34m[info]\033[0m  $*"; }
ok()    { echo -e "\033[1;32m[ok]\033[0m    $*"; }
warn()  { echo -e "\033[1;33m[warn]\033[0m  $*"; }
ask()   { read -rp $'\033[1;35m[?]\033[0m     '"$* [y/N] " ans; [[ "$ans" =~ ^[Yy]$ ]]; }

# === 1. Systémové balíčky ===
install_apt() {
    local pkgs=(zsh stow btop ripgrep fzf bat fd-find git curl wget)
    info "Instalace apt balíčků: ${pkgs[*]}"
    sudo apt update -qq
    sudo apt install -y -qq "${pkgs[@]}"
    ok "Apt balíčky nainstalovány"
}

# === 2. Změna login shellu ===
set_zsh() {
    if [[ "$SHELL" != */zsh ]]; then
        info "Změna login shellu na zsh"
        chsh -s "$(which zsh)"
        ok "Login shell změněn na zsh (projeví se po novém přihlášení)"
    else
        ok "Zsh je už výchozí shell"
    fi
}

# === 3. Oh-My-Zsh + external pluginy ===
install_omz() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        info "Instalace Oh-My-Zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
        ok "Oh-My-Zsh nainstalován"
    else
        ok "Oh-My-Zsh již existuje"
    fi

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local plugins=(
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-history-substring-search"
    )
    for plugin in "${plugins[@]}"; do
        local name="${plugin##*/}"
        local dest="$ZSH_CUSTOM/plugins/$name"
        if [[ ! -d "$dest" ]]; then
            info "Klonování $name"
            git clone "https://github.com/$plugin.git" "$dest"
        else
            ok "$name již existuje"
        fi
    done
}

# === 4. Nerd Font ===
install_nerd_font() {
    if fc-list | grep -qi "JetBrainsMono.*Nerd"; then
        ok "JetBrainsMono Nerd Font již nainstalován"
    else
        info "Instalace JetBrainsMono Nerd Font"
        mkdir -p "$HOME/.local/share/fonts"
        curl -sSfL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o /tmp/JetBrainsMono.tar.xz
        tar xf /tmp/JetBrainsMono.tar.xz -C "$HOME/.local/share/fonts/"
        fc-cache -f "$HOME/.local/share/fonts/"
        rm /tmp/JetBrainsMono.tar.xz
        ok "JetBrainsMono Nerd Font nainstalován"
    fi
}

# === 5. CLI nástroje ===
install_p10k() {
    local dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$dest" ]]; then
        info "Instalace Powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$dest"
        ok "Powerlevel10k nainstalován"
    else
        ok "Powerlevel10k již existuje"
    fi
}

install_zoxide() {
    if ! command -v zoxide &>/dev/null; then
        info "Instalace zoxide"
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
        ok "zoxide nainstalován"
    else
        ok "zoxide již nainstalován ($(zoxide --version))"
    fi
}

install_lazydocker() {
    if ! command -v lazydocker &>/dev/null; then
        info "Instalace lazydocker"
        local version
        version=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
        curl -sSfL "https://github.com/jesseduffield/lazydocker/releases/download/v${version}/lazydocker_${version}_Linux_x86_64.tar.gz" | tar xz -C /tmp lazydocker
        mv /tmp/lazydocker "$HOME/.local/bin/lazydocker"
        chmod +x "$HOME/.local/bin/lazydocker"
        ok "lazydocker $version nainstalován"
    else
        ok "lazydocker již nainstalován ($(lazydocker --version | head -1))"
    fi
}

install_dsdev() {
    if ! command -v dsdev &>/dev/null; then
        info "Instalace dsdev"
        if command -v go &>/dev/null; then
            GOBIN="$HOME/.local/bin" go install git.digital.cz/ds/dsdev-go@latest
            ok "dsdev nainstalován via go install"
        else
            warn "Go není nainstalované — dsdev nelze nainstalovat. Nainstaluj Go a spusť: GOBIN=~/.local/bin go install git.digital.cz/ds/dsdev-go@latest"
        fi
    else
        ok "dsdev již nainstalován ($(dsdev version 2>/dev/null || echo 'installed'))"
    fi
}

install_claude() {
    if ! command -v claude &>/dev/null; then
        info "Instalace Claude Code"
        if command -v npm &>/dev/null; then
            npm install -g @anthropic-ai/claude-code
            ok "Claude Code nainstalován"
        else
            warn "npm není nainstalované — Claude Code nelze nainstalovat. Nainstaluj Node.js a spusť: npm install -g @anthropic-ai/claude-code"
        fi
    else
        ok "Claude Code již nainstalován ($(claude --version 2>/dev/null || echo 'installed'))"
    fi
}

install_zellij() {
    if ! command -v zellij &>/dev/null; then
        info "Instalace zellij"
        local version
        version=$(curl -s https://api.github.com/repos/zellij-org/zellij/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
        curl -sSfL "https://github.com/zellij-org/zellij/releases/download/v${version}/zellij-x86_64-unknown-linux-musl.tar.gz" | tar xz -C "$HOME/.local/bin"
        chmod +x "$HOME/.local/bin/zellij"
        ok "zellij $version nainstalován"
    else
        ok "zellij již nainstalován ($(zellij --version))"
    fi
}

install_lazygit() {
    if ! command -v lazygit &>/dev/null; then
        info "Instalace lazygit"
        local version
        version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
        curl -sSfL "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" | tar xz -C /tmp lazygit
        mv /tmp/lazygit "$HOME/.local/bin/lazygit"
        chmod +x "$HOME/.local/bin/lazygit"
        ok "lazygit $version nainstalován"
    else
        ok "lazygit již nainstalován ($(lazygit --version | head -1))"
    fi
}

install_eza() {
    if ! command -v eza &>/dev/null; then
        info "Instalace eza"
        sudo apt install -y -qq eza 2>/dev/null || {
            warn "eza není v apt — zkus: cargo install eza"
        }
    else
        ok "eza již nainstalován ($(eza --version | head -1))"
    fi
}

install_dust() {
    if ! command -v dust &>/dev/null; then
        info "Instalace dust"
        local version
        version=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
        curl -sSfL "https://github.com/bootandy/dust/releases/download/v${version}/dust-v${version}-x86_64-unknown-linux-gnu.tar.gz" | tar xz -C /tmp --strip-components=1 "dust-v${version}-x86_64-unknown-linux-gnu/dust"
        mv /tmp/dust "$HOME/.local/bin/dust"
        chmod +x "$HOME/.local/bin/dust"
        ok "dust $version nainstalován"
    else
        ok "dust již nainstalován ($(dust --version))"
    fi
}

install_delta() {
    if ! command -v delta &>/dev/null; then
        info "Instalace delta"
        local version
        version=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
        curl -sSfL "https://github.com/dandavison/delta/releases/download/${version}/git-delta_${version#v}_amd64.deb" -o /tmp/delta.deb
        sudo dpkg -i /tmp/delta.deb
        rm /tmp/delta.deb
        ok "delta nainstalován"
    else
        ok "delta již nainstalován ($(delta --version | head -1))"
    fi
}

install_glow() {
    if ! command -v glow &>/dev/null; then
        info "Instalace glow"
        local version
        version=$(curl -s https://api.github.com/repos/charmbracelet/glow/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
        curl -sSfL "https://github.com/charmbracelet/glow/releases/download/v${version}/glow_${version}_Linux_x86_64.tar.gz" | tar xz -C /tmp --strip-components=1 "glow_${version}_Linux_x86_64/glow"
        mv /tmp/glow "$HOME/.local/bin/glow"
        chmod +x "$HOME/.local/bin/glow"
        ok "glow $version nainstalován"
    else
        ok "glow již nainstalován ($(glow --version 2>/dev/null || echo 'installed'))"
    fi
}

install_httpie() {
    if ! command -v http &>/dev/null; then
        info "Instalace httpie"
        sudo apt install -y -qq httpie 2>/dev/null || {
            warn "httpie není v apt — zkus: pip install httpie"
        }
    else
        ok "httpie již nainstalován ($(http --version 2>/dev/null || echo 'installed'))"
    fi
}

# === 7. Stow symlinky ===
stow_packages() {
    info "Vytváření symlinků pomocí stow"
    cd "$DOTFILES_DIR"
    mkdir -p "$HOME/.local/bin" "$HOME/.config" "$HOME/.claude"

    if [[ "${1:-}" == "--adopt" ]]; then
        stow --adopt -v -t "$HOME" "${STOW_PACKAGES[@]}"
        warn "Stow --adopt použit. Zkontroluj 'git diff' pro změny."
    else
        stow -v -t "$HOME" "${STOW_PACKAGES[@]}"
    fi
    ok "Symlinky vytvořeny"
}

# === Main ===
main() {
    echo ""
    echo "  ╔══════════════════════════════╗"
    echo "  ║    .dotfiles installer       ║"
    echo "  ╚══════════════════════════════╝"
    echo ""

    mkdir -p "$HOME/.local/bin"

    case "${1:-all}" in
        apt)      install_apt ;;
        zsh)      set_zsh ;;
        omz)      install_omz ;;
        fonts)    install_nerd_font ;;
        tools)    install_p10k; install_zoxide; install_lazydocker; install_dsdev; install_claude; install_zellij; install_lazygit; install_eza; install_delta; install_dust; install_glow; install_httpie ;;
        stow)     stow_packages "${2:-}" ;;
        all)
            install_apt
            set_zsh
            install_omz
            install_nerd_font
            install_p10k
            install_zoxide
            install_lazydocker
            install_dsdev
            install_claude
            install_zellij
            install_lazygit
            install_eza
            install_delta
            install_dust
            install_glow
            install_httpie
            stow_packages "${2:-}"
            echo ""
            ok "Hotovo! Otevři nový terminál. Spusť 'p10k configure' pro nastavení promptu."
            ;;
        *)
            echo "Použití: $0 [apt|zsh|omz|fonts|tools|stow [--adopt]|all]"
            exit 1
            ;;
    esac
}

main "$@"
