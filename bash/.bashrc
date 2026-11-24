# Neinteraktivní shell (skripty, scp, Claude Code snapshot) — nic nenačítat
case $- in
    *i*) ;;
      *) return;;
esac

# === Doplňování (git, docker, ssh… z balíčku bash-completion) ===
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# === Historie ===
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend checkwinsize

# Šipky nahoru/dolů hledají v historii podle rozepsaného začátku příkazu
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

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

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# === Aliasy ===
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# === Zellij integrace ===
_zellij_tab_prompt() {
    if [[ -n "$ZELLIJ" ]]; then
        command zellij action rename-tab "${PWD##*/}"
    fi
}
PROMPT_COMMAND="_zellij_tab_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

# === Machine-local overrides (netrackováno) ===
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# === Prompt ===
command -v starship &>/dev/null && eval "$(starship init bash)"

# Zoxide až za Starshipem — ten jinak přepíše PROMPT_COMMAND a zahodí __zoxide_hook
export _ZO_DOCTOR=0
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
