# Sam's dotfiles

macOS setup: zsh (oh-my-zsh + starship), mise, zoxide, tmux, nvim, Ghostty, git and a few Claude Code skills.

Everything in `home/` is symlinked into `~`, so editing `~/.zshrc` edits this repo.

## New machine

1. Install [Homebrew](https://brew.sh).
2. Clone this repo to `~/dotfiles`.
3. Install packages: `brew bundle --file ~/dotfiles/Brewfile`
4. Link the dotfiles: `~/dotfiles/bootstrap.sh`
5. Create `~/.gitconfig.local`:
   ```ini
   [user]
   	name = Sam Fleming
   	email = you@example.com
   	signingkey = /Users/you/.ssh/id_ed25519.pub
   [commit]
   	gpgsign = true
   ```
6. Open tmux and press `prefix + I` to install tmux plugins.

`bootstrap.sh` is safe to re-run. Anything it would replace is moved to `~/.dotfiles-backup/<timestamp>/` first.

## Adding a file

1. Move it into `home/` at the same path it has under `~`.
2. Run `./bootstrap.sh`.

`.config`, `.tmux`, `.claude` and `.claude/skills` are linked one entry at a time, because other tools keep files there too. Everything else in `home/` is linked as a whole.

## Updating the Brewfile

```bash
brew bundle dump --file ~/dotfiles/Brewfile --force --no-vscode
```

## Credits

Started life as a fork of [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles). Parts of `.aliases`, `.functions` and `.gitconfig` still come from there, under the MIT licence in `LICENSE-MIT.txt`.
