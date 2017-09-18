DOTFILES := $(shell pwd)

install: zsh tmux vim

zsh: 
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
	wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
	wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
	mv PowerlineSymbols.otf ~/.local/share/fonts/
	fc-cache -vf ~/.local/share/fonts/
	mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
	ln -fs $(DOTFILES)/.zshrc $(HOME)/.zshrc

tmux:
	ln -fs $(DOTFILES)/.tmux.conf $(HOME)/.tmux.conf
	ln -fs $(DOTFILES)/.tmux.conf.local $(HOME)/.tmux.conf.local

vim:
	ln -fs $(DOTFILES)/.vimrc $(HOME)/.vimrc
