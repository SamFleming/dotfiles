#!/usr/bin/env bash
# Symlink everything in home/ into ~. Anything already there is moved to ~/.dotfiles-backup/<timestamp>/ first.
set -euo pipefail
cd "$(dirname "$0")"
repo=$PWD/home
backup=~/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)

link() {
	local src=$repo/$1 dst=~/$1
	[ "$(readlink "$dst" 2>/dev/null)" = "$src" ] && return
	if [ -e "$dst" ] || [ -L "$dst" ]; then
		mkdir -p "$backup/$(dirname "$1")"
		mv "$dst" "$backup/$1"
		echo "backed up ~/$1"
	fi
	mkdir -p "$(dirname "$dst")"
	ln -s "$src" "$dst"
	echo "linked ~/$1"
}

# These folders also hold files from other tools, so link their children
shared=" .config .tmux .claude .claude/skills "
walk() {
	local f rel
	for f in "$repo${1:+/$1}"/.[!.]* "$repo${1:+/$1}"/*; do
		[ -e "$f" ] || continue
		rel=${f#"$repo"/}
		if [[ $shared == *" $rel "* ]]; then walk "$rel"; else link "$rel"; fi
	done
}
walk ""

# Cloned rather than installed: the oh-my-zsh installer overwrites ~/.zshrc
[ -d ~/.oh-my-zsh ] || git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
[ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

[ -f ~/.gitconfig.local ] || echo "Create ~/.gitconfig.local with your [user] name, email and signingkey (see README)"
