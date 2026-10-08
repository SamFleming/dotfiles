#!/usr/bin/env bash
# Set up this Mac from the repo. Safe to re-run.
#   ./bootstrap.sh              full setup: Homebrew, Brewfile, links, plugins, tools, Claude Code
#   ./bootstrap.sh zsh git      only link the named packages from home/
set -euo pipefail
cd "$(dirname "$0")"

if [ $# -eq 0 ]; then
	if ! command -v brew >/dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
	# Install what's missing only. Upgrades stay a deliberate `brew upgrade`
	brew bundle check --no-upgrade --file Brewfile >/dev/null || brew bundle install --no-upgrade --file Brewfile || echo "Some Brewfile entries failed, see above"
fi
command -v stow >/dev/null || { echo "stow is missing: brew install stow"; exit 1; }

# Other tools write into these folders. They must exist as real
# folders first, or Stow links the whole folder and those files end up in this repo.
mkdir -p ~/.config ~/.tmux/plugins ~/.claude/skills ~/Library/Application\ Support/k9s

# Every folder in home/ is a package
cd home
if [ $# -gt 0 ]; then packages=("$@"); else packages=(*/); packages=("${packages[@]%/}"); fi
# One at a time: stow 2.4.1 errors ("invalid target: .config") restowing several packages when only some are linked
for p in "${packages[@]}"; do stow --restow --target ~ "$p"; done
cd ..

[ $# -eq 0 ] || exit 0

# Cloned rather than installed: the oh-my-zsh installer overwrites ~/.zshrc
[ -d ~/.oh-my-zsh ] || git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
[ -d ~/.tmux/plugins/tpm ] || git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins >/dev/null

if [ ! -f ~/.gitconfig.local ]; then
	read -rp "Git name: " name
	read -rp "Git email: " email
	key=$(ls ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub 2>/dev/null | head -1 || true)
	{
		printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email"
		if [ -n "$key" ]; then printf '\tsigningkey = %s\n[commit]\n\tgpgsign = true\n' "$key"; fi
	} > ~/.gitconfig.local
	[ -n "$key" ] || echo "No SSH key found, so commits won't be signed. Add signingkey to ~/.gitconfig.local later."
fi

mise install --yes

command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
