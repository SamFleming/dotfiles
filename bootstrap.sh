#!/usr/bin/env bash
# Symlink home/ into ~ with GNU Stow. Safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"

# Other tools write into these folders. They must exist as real
# folders first, or Stow links the whole folder and those files end up in this repo.
mkdir -p ~/.config ~/.tmux/plugins ~/.claude/skills

stow --restow --target ~ home

# Cloned rather than installed: the oh-my-zsh installer overwrites ~/.zshrc
[ -d ~/.oh-my-zsh ] || git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
[ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

[ -f ~/.gitconfig.local ] || echo "Create ~/.gitconfig.local with your [user] name, email and signingkey (see README)"
