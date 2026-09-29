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

```bash
git clone https://github.com/SamFleming/dotfiles.git ~/dotfiles   # macOS offers to install git first
~/dotfiles/bootstrap.sh
```

`bootstrap.sh` then:

1. Installs Homebrew if it's missing, then everything in the `Brewfile` that isn't installed yet. It never upgrades; run `brew upgrade` for that.
2. Links every package in `home/` into `~`.
3. Clones oh-my-zsh and tpm, and installs the tmux plugins.
4. Asks for your git name and email and writes `~/.gitconfig.local`. It signs commits with `~/.ssh/id_ed25519.pub` (or `id_rsa.pub`) if one exists.
5. Runs `mise install` for the global tools (Node, Go and the Go tools).
6. Installs Claude Code.

To link only some packages, and skip everything else: `~/dotfiles/bootstrap.sh zsh git nvim`

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
