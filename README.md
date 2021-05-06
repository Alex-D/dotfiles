My Windows 10 Setup & Dotfiles
==============================

Goals of this setup
-------------------

- Working on Windows 10, on WSL 2 filesystem
- Having a visually nice terminal (Windows Terminal)
- zsh as my main shell
- Using Docker and Docker Compose directly from zsh
- Using IntelliJ IDEA directly from WSL 2


What's in this setup?
---------------------

- Host: Windows 10 2004+
  - Ubuntu via WSL 2 (Windows Subsystem for Linux)
  - Docker Desktop
- Terminal: Windows Terminal
- Shell: zsh
  - git
  - docker (works with Docker Desktop)
  - docker-compose (works with Docker Desktop)
- Node.js (using [Volta](https://volta.sh))
  - node
  - npm
  - yarn
- IDE: IntelliJ IDEA, under WSL 2, used on Windows via VcXsrv
- WSL Bridge: allow exposing WSL 2 ports on the network


Other guides
------------

- [GitBash with zsh](git-bash/README.md), for better git performances on Windows filesystem
- [Server](server/README.md)


----------------------


Setup WSL 2
-----------

- Enable WSL 2 and update the linux kernel ([Source](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

```powershell
# In PowerShell as Administrator

# Enable WSL and VirtualMachinePlatform features
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Download and install the Linux kernel update package
$wslUpdateInstallerUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$downloadFolderPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$wslUpdateInstallerFilePath = "$downloadFolderPath/wsl_update_x64.msi"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($wslUpdateInstallerUrl, $wslUpdateInstallerFilePath)
Start-Process -Filepath "$wslUpdateInstallerFilePath"

# Set WSL default version to 2
wsl --set-default-version 2
```

- [Install Ubuntu from Microsoft Store](https://www.microsoft.com/fr-fr/p/ubuntu/9nblggh4msv6)


Install common dependencies
---------------------------

```shell script
#!/bin/bash

sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    git \
    make \
    tig \
    tree \
    zsh
```


GPG key
-------

If you already have a GPG key, restore it. If you did not have one, you can create one.

### Restore

- On old system, create a backup of a GPG key
  - `gpg --list-secret-keys`
  - `gpg --export-secret-keys {{KEY_ID}} > /tmp/private.key`
- On new system, import the key:
  - `gpg --import /tmp/private.key`
- Delete the `/tmp/private.key` on both side

### Create

- `gpg --full-generate-key`

[Read GitHub documentation about generating a new GPG key for more details](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key).


Setup Git
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
git config --global core.pager /usr/bin/less
git config --global core.excludesfile ~/.gitignore

# Generate a new SSH key
ssh-keygen -t rsa -b 4096 -C "${email}"

# Start ssh-agent and add the key to it
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Display the public key ready to be copy pasted to GitHub
cat ~/.ssh/id_rsa.pub
```

- [Add the generated key to GitHub](https://github.com/settings/ssh/new)


Setup zsh
---------

```shell script
#!/bin/zsh

# Clone the dotfiles repository
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

# Create .screen folder used by .zshrc
mkdir ~/.screen && chmod 700 ~/.screen

# Change default shell to zsh
chsh -s $(which zsh)
```


Docker
------

### Install Docker Desktop

- [Install Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
- Make sure that the "Use the WSL 2 based engine" option is checked in Docker Desktop settings

### Setup Docker CLI

```shell script
#!/bin/zsh

# Add Docker to sources.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
versionCodename=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d= -f2)
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${versionCodename} stable"

# Install tools
sudo apt update && sudo apt install -y \
    docker-ce

# Add user to docker group
sudo usermod -aG docker $USER
```


Node.js
-------

```shell script
#!/bin/zsh

# Install Volta
mkdir -p $VOLTA_HOME
curl https://get.volta.sh | bash -s -- --skip-setup

# Install node and package managers
volta install node npm yarn
```


IntelliJ IDEA
-------------

I run IntelliJ IDEA in WSL 2, and get its GUI on Windows via X Server (VcXsrv).

### Setup VcXsrv

- [Install VcXsrv (XLaunch)](https://sourceforge.net/projects/vcxsrv/)

```shell script
windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Run VcXsrv at startup
cp ~/dev/dotfiles/config.xlaunch "${windowsUserProfile}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
```

### Install IntelliJ IDEA

```shell script
#!/bin/zsh

# Install IDEA dependencies
sudo apt update && sudo apt install -y \
    fontconfig \
    libxss1 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgbm1 \
    libpangocairo-1.0-0 \
    libcups2 \
    libxkbcommon0

# Create install folder
sudo mkdir /opt/idea

# Allow your user to run IDEA updates from GUI
sudo chown $UID:$UID /opt/idea

# Download IntelliJ IDEA
curl -L "https://download.jetbrains.com/product?code=IIU&latest&distribution=linux" | tar vxz -C /opt/idea --strip 1
```


Setup Windows Terminal
----------------------

- [Download and install JetBrains Mono](https://www.jetbrains.com/mono/)
- [Install Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701)

```shell script
#!/bin/zsh

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Copy Windows Terminal settings
cp ~/dev/dotfiles/terminal-settings.json ${windowsUserProfile}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
```


WSL Bridge
----------

When a port is listening from WSL 2, it cannot be reached.
You need to create port proxies for each port you want to use.
To avoid doing than manually each time I start my computer, I've made the `wslb` alias that will run the `wsl2bridge.ps1` script in an admin Powershell.

```shell script
#!/bin/zsh

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Get the hacky network bridge script
cp ~/dev/dotfiles/wsl2-bridge.ps1 ${windowsUserProfile}/wsl2-bridge.ps1
```

In order to allow `wsl2-bridge.ps1` script to run, you need to update your PowerShell execution policy.

```powershell
# In PowerShell as Administrator

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
PowerShell -File $env:USERPROFILE\\wsl2-bridge.ps1
```

Then, when port forwarding does not work between WSL 2 and Windows, run `wslb` from zsh:

```shell script
#!/bin/zsh

wslb
```

Note: This is a custom alias. See [`.aliases.zsh`](.aliases.zsh) for more details


Limit WSL 2 RAM consumption
---------------------------

```shell script
#!/bin/zsh

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Avoid too much RAM consumption
cp ~/dev/dotfiles/.wslconfig ${windowsUserProfile}/.wslconfig
```

Note: You can adjust the RAM amount in `.wslconfig` file. Personally, I set it to 8 GB.


Setup Git Filter Repo
---------------------

```shell script
#!/bin/zsh

git clone git@github.com:newren/git-filter-repo.git /tmp/git-filter-repo
cd /tmp/git-filter-repo
make snag_docs
cp -a git-filter-repo $(git --exec-path)
cp -a Documentation/man1/git-filter-repo.1 $(git --man-path)/man1
cp -a Documentation/html/git-filter-repo.html $(git --html-path)
cd -
rm -rf /tmp/git-filter-repo
```
