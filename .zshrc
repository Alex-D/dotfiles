# Do not want background jobs to be at a lower priority
unsetopt BG_NICE

# Allows to shorten some paths
setopt AUTO_NAME_DIRS
[ -f ~/.zsh_autonamed_dirs.zsh ] && source ~/.zsh_autonamed_dirs.zsh

# Custom aliases
[ -f ~/.aliases.zsh ] && source ~/.aliases.zsh

# All zsh plugins (Generated via Antibody)
[ -f ~/.zsh_plugins.zsh ] && source ~/.zsh_plugins.zsh

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Docker for Windows <> WSL
export DOCKER_HOST=tcp://localhost:2375

## History command configuration
HISTSIZE=5000                 # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=5000                 # Number of history entries to save to disk
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

clear
