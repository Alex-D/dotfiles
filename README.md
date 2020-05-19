My Windows 10 Setup & Dotfiles
==============================

Goals of this setup
-------------------

- Working on Windows 10 Pro (Pro is needed because WSL2 uses Hyper-V under the hood)
- Having a visually nice terminal (Windows Terminal)
- zsh as my main shell
- Using Docker and Docker Compose directly from zsh
- Using IntelliJ IDEA directly from WSL 2


What's in this setup?
---------------------

- Host: Windows 10 Pro 2004+
  - Ubuntu via WSL 2 (Windows Subsystem for Linux)
  - Docker for Windows
- Terminal: Windows Terminal
- Shell: zsh
  - git
  - docker (works with Docker for Windows)
  - docker-compose (works with Docker for Windows)
  - node
  - yarn
- IDE: IntelliJ IDEA, under WSL 2, used on Windows via XLaunch


Install
-------

### On Windows

- [Enable WSL 2 (Ubuntu)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
- [Install Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
  - In Docker for Windows settings, check "Use the WSL 2 based engine"
- [Download and install JetBrains Mono](https://www.jetbrains.com/mono/)
- [Install Xming (XLaunch)](https://sourceforge.net/projects/xming/files/latest/download)
- [Install Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701)
- Open Windows Terminal
- Go to Ubuntu via `bash`

### On WSL 2

#### Install dependencies

```bash
# curl
sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Node.js to sources.list
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# Add Yarn to sources.list
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Add Docker to sources.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   bionic \
   stable"

# Install tools
sudo apt update && sudo apt upgrade
sudo apt install -y \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    fontconfig \
    git \
    make \
    nodejs \
    tig \
    yarn \
    zsh \

# Add user to docker group
sudo usermod -aG docker $USER

# Create .screen folder used by .zshrc
mkdir ~/.screen && chmod 700 ~/.screen
```

#### Restore (or generate) the GPG key

- On old system, create a backup of a GPG key
  - `gpg --list-secret-keys`
  - `gpg --export-secret-keys {{KEY_ID}} > /tmp/private.key`
- On new system, import the key:
  - `gpg --import /tmp/private.key`
- Delete the `/tmp/private.key` on both side

#### Setup Git

```bash
# Set username and email for next commands
email="contact@alex-d.fr"
username="Alex-D"
gpgkeyid="8FA78E6580B1222A"

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

#### Setup zsh

```bash
# Finally clone the repository
mkdir -p ~/dev/dotfiles
git clone git@github.com:Alex-D/dotfiles.git ~/dev/dotfiles

# Install Antibody and generate .zsh_plugins.zsh
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
antibody bundle < ~/dev/dotfiles/zsh_plugins > ~/.zsh_plugins.zsh

# Link custom dotfiles
ln -sf ~/dev/dotfiles/.aliases.zsh ~/.aliases.zsh
ln -sf ~/dev/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dev/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dev/dotfiles/.gitignore ~/.gitignore
```

#### Install IntelliJ IDEA

```bash
sudo mkdir /opt/idea
# Allow user to run IDEA updates from GUI
sudo chmod 777 /opt/idea
curl -L "https://download.jetbrains.com/product?code=IIU&latest&distribution=linux" | tar vxz -C /opt/idea --strip 1
```

#### Copy useful files to Windows

```bash
windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Windows Terminal settings
cp ~/dev/dotfiles/terminal-settings.json ${windowsUserProfile}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json

# Avoid too much RAM consumption
cp ~/dev/dotfiles/.wslconfig ${windowsUserProfile}/.wslconfig

# Get the hacky network bridge script
cp ~/dev/dotfiles/wsl2-bridge.ps1 ${windowsUserProfile}/wsl2-bridge.ps1
```

- Then, when port forwarding does not work between WSL 2 and Windows

```bash
# This is a custom alias, see .aliases.zsh for more details
wslb
```


