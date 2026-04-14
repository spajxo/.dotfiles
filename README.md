# .dotfiles

Dotfiles spravované pomocí [GNU Stow](https://www.gnu.org/software/stow/).

## Quick start

```bash
git clone https://github.com/spajxo/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh all --adopt
```

`--adopt` při prvním spuštění přesune existující soubory do repo a nahradí je symlinky.

## Packages

| Package | Soubory | Popis |
|---------|---------|-------|
| `zsh` | `.zshrc`, `.zsh_aliases` | Zsh + Oh-My-Zsh + Starship prompt |
| `git` | `.gitconfig` | Git konfigurace, aliasy |
| `helix` | `.config/helix/config.toml` | Helix editor |
| `kitty` | `.config/kitty/kitty.conf` | Kitty terminál |
| `starship` | `.config/starship.toml` | Starship prompt |
| `zellij` | `.config/zellij/config.kdl` | Zellij terminal multiplexer |
| `btop` | `.config/btop/btop.conf` | Btop resource monitor |
| `claude` | `.claude/CLAUDE.md`, `.claude/keybindings.json` | Claude Code |

## Použití

```bash
make install    # Plná instalace (apt + omz + tools + stow)
make stow       # Jen vytvořit symlinky
make unstow     # Odstranit symlinky
make adopt      # Stow --adopt (přesune existující soubory do repo)
make tools      # Nainstalovat CLI nástroje (zoxide, lazydocker, dsdev, claude)
make optional   # Volitelné nástroje (starship, eza, delta, zellij, lazygit)
```

Jednotlivé sekce install scriptu:

```bash
./install.sh apt       # Systémové balíčky
./install.sh omz       # Oh-My-Zsh + external pluginy
./install.sh tools     # CLI nástroje
./install.sh optional  # Volitelné nástroje (interaktivní)
./install.sh stow      # Symlinky
```

## Přidání nového package

1. Vytvoř adresář: `mkdir -p novy/.config/novy`
2. Přidej config: `cp ~/.config/novy/config.toml novy/.config/novy/`
3. Stow: `stow -v -t $HOME novy`
4. Přidej do `STOW_PACKAGES` v `Makefile`

## Machine-local overrides

Soubor `~/.zshrc.local` (netrackovaný) pro machine-specific nastavení:

```zsh
export SSH_AUTH_SOCK=/home/user/.bitwarden-ssh-agent.sock
export JAVA_HOME="/snap/android-studio/209/jbr"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$JAVA_HOME/bin:$ANDROID_HOME/platform-tools"
```
