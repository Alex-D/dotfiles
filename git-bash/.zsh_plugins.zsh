#!/bin/zsh

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "${ZINIT_HOME}/zinit.zsh" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

    source "${ZINIT_HOME}/zinit.zsh"

    # Reload Zsh to install Zinit
    exec zsh
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light romkatv/powerlevel10k
zinit light rupa/z

zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git
zinit snippet OMZ::plugins/tig
zinit snippet OMZ::plugins/ssh-agent
zinit snippet OMZ::plugins/gpg-agent
zinit snippet OMZ::plugins/colored-man-pages

# Autocompletion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

# Autoload compaudit
autoload -Uz compinit && compinit
