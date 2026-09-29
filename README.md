# Sam's dotfiles

macOS setup: zsh (oh-my-zsh + starship), mise, zoxide, tmux, nvim, Ghostty, git and a few Claude Code skills.

Each folder in `home/` is a [GNU Stow](https://www.gnu.org/software/stow/) package, symlinked into `~`. Editing `~/.zshrc` edits this repo.

| Package | What's in it |
|---|---|
| `zsh` | `.zshrc`, `.zprofile`, `.zshenv`, `.aliases`, `.functions`, `.hushlogin` |
| `shell` | `.inputrc`, `.editorconfig`, `.curlrc`, `.wgetrc` |
| `git` | `.gitconfig`, `.config/git/` (global ignore and attributes) |
| `nvim` | `.config/nvim/` |
| `tmux` | `.tmux.conf`, `.tmux/themes/` |
| `ghostty` | `.config/ghostty/` |
| `starship` | `.config/starship.toml` |
| `mise` | `.config/mise/` (global tool versions) |
| `claude` | Claude Code skills and statusline |

## New machine

1. Install [Homebrew](https://brew.sh).
2. Clone this repo to `~/dotfiles`.
3. Install packages: `brew bundle --file ~/dotfiles/Brewfile`
4. Link the dotfiles: `~/dotfiles/bootstrap.sh`. To link only some packages: `~/dotfiles/bootstrap.sh zsh git nvim`
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
7. Install Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`

`bootstrap.sh` is safe to re-run. If a real file is already in the way, Stow aborts without changing anything. To keep the repo's version:

```bash
cd ~/dotfiles/home
stow --adopt --target ~ zsh    # moves the existing files into the package
git restore .                  # then throws their contents away
```

## Adding a file

1. Move it into a package, at the same path it has under `~`. For example `~/.config/foo/config` goes in `home/foo/.config/foo/config`.
2. Run `./bootstrap.sh`.

To unlink a package: `cd ~/dotfiles/home && stow --delete --target ~ foo`

Always link through `bootstrap.sh`, not plain `stow`. Stow links a folder as a whole unless it already exists in `~`. `bootstrap.sh` creates `~/.config`, `~/.tmux/plugins` and `~/.claude/skills` first, because other tools write into them and those files must not end up here.

## Updating the Brewfile

```bash
brew bundle dump --file ~/dotfiles/Brewfile --force --no-vscode
```

## Credits

Started life as a fork of [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles). Parts of `.aliases`, `.functions` and `.gitconfig` still come from there, under the MIT licence in `LICENSE-MIT.txt`.
