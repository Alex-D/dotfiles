# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/ademode/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="refined"

# zsh-nvm configuration
# We want fast terminal startup
# So let's lazy load nvm stuff
NVM_LAZY_LOAD=true

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  z
  git
  tig
  ssh-agent
  docker
  docker-compose
  composer
  zsh-nvm
  npm
  yarn
)

source $ZSH/oh-my-zsh.sh

# User configuration

DEFAULT_USER='ademode'

# Do not want background jobs to be at a lower priority
unsetopt BG_NICE

# Preferred editor for local and remote sessions
export EDITOR='vim'

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Docker for Windows <> WSL
export DOCKER_HOST=tcp://localhost:2375

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias sf="docker-compose exec php bin/console"
alias dc="docker-compose exec php composer"
