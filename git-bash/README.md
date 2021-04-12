GitBash with zsh
================

Goals of this setup
-------------------

- Working on Windows 10, on Windows filesystem
- Having a visually nice terminal (Windows Terminal)
- zsh as my main shell


----------------------


Install GitBash
---------------

- [Download Git for Windows SDK](https://github.com/git-for-windows/build-extra/releases/latest)
- Run the exe (can take 10+ minutes)


Setup git
---------

```shell script
#!/bin/bash

# Set username and email for next commands
email="contact@alex-d.fr"
username="Alex-D"
gpgkeyid="8FA78E6580B1222A"

# Configure Git
git config --global user.email "${email}"
git config --global user.name "${username}"
git config --global user.signingkey "${gpgkeyid}"
git config --global commit.gpgsign true
git config --global gpg.program "$HOME/dotfiles/git-bash/.gpg-pinentry-loopback"
git config --global core.pager /usr/bin/less
git config --global core.excludesfile ~/.gitignore

# Use ssh key from WSL2
git config --global core.sshCommand "ssh -i //wsl$/Ubuntu/home/ademode/.ssh/id_rsa"
```


Setup zsh
---------

```shell script
#!/bin/bash

pacman -S zsh

# Launch zsh
zsh

# Clone the dotfiles repository
mkdir -p ~/dotfiles
git clone git@github.com:Alex-D/dotfiles.git ~/dotfiles

# Link custom dotfiles
ln -sf ~/dotfiles/.aliases.zsh ~/.aliases.zsh
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitignore ~/.gitignore
ln -sf ~/dotfiles/git-bash/.zsh_plugins.zsh ~/.zsh_plugins.zsh

# GPG Agent
mkdir ~/.gnupg
ln -sf ~/dotfiles/git-bash/gpg-agent.conf ~/.gnupg/gpg-agent.conf
gpg-connect-agent reloadagent /bye

# Git autocompletion
mkdir -p ~/.zsh
cd ~/.zsh
curl -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o _git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
```


GPG key
-------

Import all GPG keys from WSL 2

```shell script
wsl.exe gpg -a --export-secret-keys | gpg --import --pinentry-mode loopback
```
