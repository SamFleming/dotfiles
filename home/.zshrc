typeset -U path  # drop duplicate PATH entries
path=(/opt/homebrew/bin /opt/homebrew/sbin $HOME/go/bin /usr/local/go/bin $HOME/.composer/vendor/bin $path)
export GOPATH=$HOME/go
export EDITOR=nvim
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""  # prompt comes from starship, see below
ZSH_DISABLE_COMPFIX=true
plugins=(git kubectl)

source ~/.aliases
source ~/.functions
source $ZSH/oh-my-zsh.sh

[ -f /opt/homebrew/share/google-cloud-sdk/path.zsh.inc ] && source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc
[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ] && source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
[ -f ~/.local/bin/env ] && source ~/.local/bin/env

# certifi CA bundle path, cached weekly to avoid spawning Python on every shell
_certifi_cache="$HOME/.cache/certifi_path"
if [[ ! -f "$_certifi_cache" ]] || [[ -n "$(find "$_certifi_cache" -mtime +7 2>/dev/null)" ]]; then
  mkdir -p "$HOME/.cache"
  python3 -c "import certifi; print(certifi.where())" 2>/dev/null > "$_certifi_cache"
fi
export CERT_PATH=$(<"$_certifi_cache")
export SSL_CERT_FILE=$CERT_PATH
export REQUESTS_CA_BUNDLE=$CERT_PATH
unset _certifi_cache

# Prompt, config in ~/.config/starship.toml
eval "$(starship init zsh)"

# Node and other tool versions per directory, from .nvmrc or mise.toml
eval "$(mise activate zsh)"

# Must stay last: zoxide hooks cd and expects nothing to override it afterwards
eval "$(zoxide init zsh)"
