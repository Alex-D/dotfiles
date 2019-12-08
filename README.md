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
	- node
	- yarn


Install
-------

### Windows side

- [Enable WSL (Ubuntu)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Install Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- In Docker for Windows settings, enable "Expose daemon" option
- [Install "Fira Mono for Powerline"](https://github.com/powerline/fonts/tree/master/FiraMono)
- [Install Hyper](https://hyper.is/#installation)
- [Install Node](https://nodejs.org/en/download/current/)
- [Install Yarn](https://yarnpkg.com/fr/docs/install#windows-stable)

### Windows Subsystem for Linux side

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
- [WSL] [Install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
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
git config --global core.excludesfile ~/.gitignore

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
mkdir -p /c/dev/dotfiles
git clone git@github.com:Alex-D/dotfiles.git /c/dev/.dotfiles
```
- [CMD] Use the custom `.hyper.js` config from this repo
```cmd
del /f %USERPROFILE%\AppData\Roaming\Hyper\.hyper.js
mklink /h %USERPROFILE%\AppData\Roaming\Hyper\.hyper.js C:\dev\dotfiles\.hyper.js
```
- Restart Hyper
- [WSL] Install `zsh`
```bash
# Install zsh
sudo apt-get update
sudo apt install zsh

# Link custom dotfiles
ln -sf /c/dev/dotfiles/.zsh_autonamed_dirs.zsh ~/.zsh_autonamed_dirs.zsh
ln -sf /c/dev/dotfiles/.aliases.zsh ~/.aliases.zsh
ln -sf /c/dev/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf /c/dev/dotfiles/.zshrc ~/.zshrc
ln -sf /c/dev/dotfiles/.gitignore ~/.gitignore

# Install Antibody and generate .zsh_plugins.zsh
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
antibody bundle < /c/dev/dotfiles/zsh_plugins > ~/.zsh_plugins.zsh
```
- [WSL] [Install node (not nvm, too slow)](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)
- [WSL] [Install yarn](https://yarnpkg.com/lang/en/docs/install/#debian-stable)
- Restart Hyper and you are ready to go!
