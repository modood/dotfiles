sshconfdir=~/.ssh

all: help

help:
	@echo "This makefile defines the following targets\n"
	@echo "  - help (default)   list available targets"
	@echo "  - dotfiles         deploy dotfiles"
	@echo "  - tmux             deploy tmux config"
	@echo "  - i3wm             deploy i3wm config"
	@echo "  - ssh              deploy ssh config"
	@echo "  - bashrc           deploy bashrc to remote machine using ansible"
	@echo

dotfiles:
	./deploy/dotfiles.sh

tmux:
	./deploy/tmux.sh

i3wm:
	cp -rf .config/i3* ~/.config

ssh:
	if [ ! -d $(sshconfdir) ]; then mkdir $(sshconfdir); fi
	if [ ! -f $(sshconfdir)/config ]; then cp -rf .ssh/config $(sshconfdir); fi

bashrc:
	ansible-playbook -i inventory playbook.yml

.PHONY: all help dotfiles tmux i3wm ssh bashrc
