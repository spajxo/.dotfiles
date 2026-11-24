STOW_PACKAGES = bash starship git helix kitty zellij btop claude

.PHONY: install stow unstow tools apt fonts

install: apt fonts tools stow
	@echo "Hotovo! Otevři nový terminál."

apt:
	./install.sh apt

fonts:
	./install.sh fonts

tools:
	./install.sh tools

stow:
	@command -v stow >/dev/null || { echo "Instaluji stow..."; sudo apt install -y stow; }
	stow -v -t $(HOME) $(STOW_PACKAGES)

unstow:
	stow -D -v -t $(HOME) $(STOW_PACKAGES)

adopt:
	@command -v stow >/dev/null || { echo "Instaluji stow..."; sudo apt install -y stow; }
	stow --adopt -v -t $(HOME) $(STOW_PACKAGES)
