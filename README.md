My Windows 10 Setup & Dotfiles
==============================

Goals of this setup
-------------------

- Working on Windows 10 Pro (Pro is needed for Hyper-V which is needed by Docker for Windows)
- Having a visually nice terminal (Hyper)
- Zsh as my main shell
- Using Docker and Docker Compose without using PowerShell (so directly from zsh)


What's in this setup?
---------------------

- Host: Windows 10 Pro
	- Windows Subsystem for Linux (Ubuntu)
	- Docker for Windows
- Terminal: Hyper
- Shell: zsh
	- git
	- docker (works with Docker for Windows)
	- docker-compose (works with Docker for Windows)


Install
-------

### Windows side

- [Enable WSL (Ubuntu)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Install Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- In Docker for Windows settings, enable "Expose deamon" option
- [Install "Fira Mono for Powerline"](https://github.com/powerline/fonts/tree/master/FiraMono)
- [Install Hyper](https://hyper.is/#installation)

### Windows Subsytem for Linux side

- Run Hyper
- [Hyper] Type `bash` from Hyper to go into WSL
- [WSL] Change WSL automount root to allow Docker volumes to work from WSL to Docker for Windows:
```bash
sudo tee /etc/wsl.conf >/dev/null <<EOL
[automount]
root = /
options = "metadata"
EOL
```
- Reboot
- [WSL] [Install Docker in WSL](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [WSL] [Install Docker Compose](https://docs.docker.com/compose/install/)
- [WSL] Restore (or generate) the GPG key
- [WSL] Install and setup Git
```bash
# Set username and email for next commands
email="contact@alex-d.fr"
username="Alex-D"
gpgkeyid="8FA78E6580B1222A"

# Install Git
sudo apt-get update
sudo apt-get install git

# Configure Git
git config --global user.email "${email}"
git config --global user.name "${username}"
git config --global user.signingkey "${gpgkeyid}"
git config --global commit.gpgsign true
git config --global core.pager /usr/bin/less

# Generate a new key
ssh-keygen -t rsa -b 4096 -C "${email}"

# Start ssh-agent and add the key to it
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Display the public key ready to be copy pasted to GitHub
cat ~/.ssh/id_rsa.pub
```
- [Add the generated key to GitHub](https://github.com/settings/ssh/new)
- [WSL] Clone this repository
```bash
# Finally clone the repository
mkdir -p /c/dev/oss/dotfiles
git clone git@github.com:Alex-D/dotfiles.git /c/dev/oss/.dotfiles
```
- [CMD] Use the custom *.hyper.js* config from this repo
```cmd
del /f %HOMEPATH%\.hyper.js
mklink /h %HOMEPATH%\.hyper.js C:\dev\oss\dotfiles\.hyper.js
```
- Restart Hyper
- [WSL] Install *zsh*
```bash
# Install zsh
sudo apt-get update
sudo apt install zsh

# Link custom dotfiles
ln -sf /c/dev/oss/dotfiles/.zsh_autonamed_dirs.zsh ~/.zsh_autonamed_dirs.zsh
ln -sf /c/dev/oss/dotfiles/.aliases.zsh ~/.aliases.zsh
ln -sf /c/dev/oss/dotfiles/.zshrc ~/.zshrc

# Install Antibody and generate .zsh_plugins.zsh
curl -sL git.io/antibody | sh -s
antibody bundle < /c/dev/oss/dotfiles/zsh_plugins > ~/.zsh_plugins.zsh
```
- [Install node (not nvm, too slow)](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)
- [Install yarn](https://yarnpkg.com/lang/en/docs/install/#debian-stable)
- Restart Hyper and you are ready to go!
