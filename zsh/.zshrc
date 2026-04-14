# Powerlevel10k instant prompt (musí být na začátku .zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# === Oh-My-Zsh ===
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Pluginy
# External pluginy (klonovat do $ZSH_CUSTOM/plugins/):
#   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
#   git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM}/plugins/zsh-history-substring-search
plugins=(
    git
    docker
    docker-compose
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
    history-substring-search
)

source $ZSH/oh-my-zsh.sh

# === Historie ===
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups hist_ignore_space

# === Keybindings ===
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# === Path ===
export PATH="$HOME/.local/bin:$PATH"

# === Tools ===
export VISUAL=hx
export EDITOR=hx

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Zoxide
export _ZO_DOCTOR=0
eval "$(zoxide init zsh)"

# Powerlevel10k konfigurace
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# === Aliasy ===
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# === Zellij integrace ===
_zellij_tab_prompt() {
    if [[ -n "$ZELLIJ" ]]; then
        command zellij action rename-tab "${PWD##*/}"
    fi
}
precmd_functions+=(_zellij_tab_prompt)

# === Machine-local overrides (netrackováno) ===
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
