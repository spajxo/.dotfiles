DOTFILES := $(shell pwd)

install: zsh tmux vim

zsh: 
	sudo apt install zsh
	rm -rf ~/.oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/themes/powerlevel9k
	wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
	wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
	mkdir -p ~/.local/share/fonts
	mv PowerlineSymbols.otf ~/.local/share/fonts/
	fc-cache -vf ~/.local/share/fonts/
	mkdir -p ~/.config/fontconfig/conf.d
	mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
	ln -fs $(DOTFILES)/.zshrc $(HOME)/.zshrc

tmux:
	sudo apt install tmux
	ln -fs $(DOTFILES)/.tmux.conf $(HOME)/.tmux.conf
	ln -fs $(DOTFILES)/.tmux.conf.local $(HOME)/.tmux.conf.local

vim:
	sudo apt install neovim
	ln -fs $(DOTFILES)/.vimrc $(HOME)/.vimrc
