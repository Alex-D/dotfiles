if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

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
