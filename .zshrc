# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="nicoulaj"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

# Customize to your needs...
export PATH=/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/Applications/XAMPP/xamppfiles/bin:/Users/sam/Mongo/mongodb-osx-x86_64-2.0.6/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/sam/android-sdk-macosx/tools:/Users/sam/android-sdk-macosx/platform-tools:/Users/sam/Library/Python/2.7/bin:~/.composer/vendor/bin
#export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:/Users/sam/Mongo/mongodb-osx-x86_64-2.0.6/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/sam/android-sdk-macosx/platform-tools

source ~/.aliases

# init z   https://github.com/rupa/z
. ~/code/z/z.sh

export EDITOR=vim

LANG="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_ALL="en_US.UTF-8"

source ~/.tmuxinator/completion.zsh

source $ZSH/oh-my-zsh.sh

export ANSIBLE_HOSTS=~/ansible_hosts
