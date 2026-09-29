# Sam's dotfiles

macOS setup: zsh (oh-my-zsh + starship), mise, zoxide, tmux, nvim, Ghostty, git and a few Claude Code skills.

`home/` is a [GNU Stow](https://www.gnu.org/software/stow/) package symlinked into `~`, so editing `~/.zshrc` edits this repo.

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

`bootstrap.sh` is safe to re-run. If a real file is already in the way, Stow aborts without changing anything. To keep the repo's version:

```bash
cd ~/dotfiles
stow --adopt --target ~ home   # moves the existing files into home/
git restore home               # then throws their contents away
```

## Adding a file

1. Move it into `home/` at the same path it has under `~`.
2. Run `./bootstrap.sh`.

Stow links a folder as a whole unless it already exists in `~`. `bootstrap.sh` creates `~/.config`, `~/.tmux/plugins` and `~/.claude/skills` first, because other tools write into them and those files must not end up here.

## Updating the Brewfile

```bash
brew bundle dump --file ~/dotfiles/Brewfile --force --no-vscode
```

## Credits

Started life as a fork of [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles). Parts of `.aliases`, `.functions` and `.gitconfig` still come from there, under the MIT licence in `LICENSE-MIT.txt`.
