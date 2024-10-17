#!/bin/sh

# Exit on error
set -e

# Clone the dotfiles repository
mkdir -p "/home/$USERNAME/dotfiles"
chown -R "$USER_UID:$USER_GID" "/home/$USERNAME/dotfiles"
git clone git@github.com:Alex-D/dotfiles.git "/home/$USERNAME/dotfiles"

# Install Antibody and generate .zsh_plugins.zsh
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
antibody bundle < "/home/$USERNAME/dotfiles/zsh_plugins" > "/home/$USERNAME/.zsh_plugins.zsh"

# Link custom dotfiles
ln -sf "/home/$USERNAME/dotfiles/.aliases.zsh" "/home/$USERNAME/.aliases.zsh"
ln -sf "/home/$USERNAME/dotfiles/.p10k.zsh" "/home/$USERNAME/.p10k.zsh"
ln -sf "/home/$USERNAME/dotfiles/.zshrc" "/home/$USERNAME/.zshrc"
ln -sf "/home/$USERNAME/dotfiles/.gitignore" "/home/$USERNAME/.gitignore"

# Create .screen folder used by .zshrc
mkdir "/home/$USERNAME/.screen" && chmod 700 "/home/$USERNAME/.screen"
