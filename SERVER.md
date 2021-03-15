My Server dotfiles
==================

OS: Debian 10
Default shell: bash

Goals of this setup
-------------------

- Debian 10 server
- Clean dedicated non-root user
- Secure connexion via SSH
- zsh as my main shell
- Serve PHP websites


Install common dependencies
---------------------------

```bash
#!/bin/bash

sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg2 \
    software-properties-common \
    man \
    perl \
    git \
    tig \
    tree \
    zsh
```


Setup a user
------------

```bash
#!/bin/bash

username="ademode"

# Create a new user (use a password generator)
sudo adduser "${username}"
sudo usermod -aG sudo "${username}"

# Logout and login with this new user

# If needed, delete default provided user (if not root)
sudo deluser --remove-home debian
```


Change hostname
---------------

```bash
#!/bin/bash

hostname="alexandredemode.fr"

sudo hostnamectl set-hostname "${hostname}"
echo "127.0.0.1 ${hostname}" | sudo tee -a /etc/hosts

# Note: if the hostname doesn't have a global internet DNS entry, 
# set 127.0.1.1 instead
```


Setup Git
---------

```bash
#!/bin/bash

# Generate a new SSH key
ssh-keygen -t rsa -b 4096 -C "${email}"

# Start ssh-agent and add the key to it
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Display the public key ready to be copy pasted to GitHub
cat ~/.ssh/id_rsa.pub
```


Setup zsh
---------

```bash
#!/bin/bash

# Clone the dotfiles repository
mkdir -p ~/dotfiles
git clone git@github.com:Alex-D/dotfiles.git ~/dotfiles

# Install Antibody and generate .zsh_plugins.zsh
curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
antibody bundle < ~/dotfiles/zsh_plugins > ~/.zsh_plugins.zsh

# Link custom dotfiles
ln -sf ~/dotfiles/.aliases.zsh ~/.aliases.zsh
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc

# Change default shell to zsh
chsh -s $(which zsh)
```


Install nginx
-------------

```bash
#!/bin/bash

sudo apt update && sudo apt install -y \
    nginx
```


Install PHP-FPM
---------------

```bash
#!/bin/bash

# Download and add the sury repository gpg key
curl https://packages.sury.org/php/apt.gpg -o /tmp/packages.sury.org.gpg
sudo apt-key add /tmp/packages.sury.org.gpg

# Add sury repository
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list

# Install PHP
php_version="5.6"
sudo apt update && sudo apt install -y \
    unzip \
    php${php_version} \
    php${php_version}-cli \
    php${php_version}-common \
    php${php_version}-fpm \
    php${php_version}-pdo
```


Install Composer
----------------

```bash
#!/bin/bash


```


Install MariaDB
---------------

```bash
#!/bin/bash

sudo apt update && sudo apt install -y \
    mariadb-server
    
sudo mysql_secure_installation
```


Setup Dropbox Uploader
----------------------

```bash
#!/bin/bash

# Download and install Dropbox Uploader
sudo curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o /usr/bin/dropbox_uploader
sudo chmod +x /usr/bin/dropbox_uploader

# First run: follow instructions
dropbox_uploader
```


Setup Dropbox Headless
----------------------

```bash
#!/bin/bash

# Install required dependencies
sudo apt update && sudo apt install -y \
    libglapi-mesa \
    libxdamage1 \
    libxfixes3 \
    libxcb-glx0 \
    libxcb-dri2-0 \
    libxcb-dri3-0 \
    libxcb-present0 \
    libxcb-sync1 \
    libxshmfence1 \
    libxxf86vm1 \
    python3-gpg

# Install CLI tool
sudo curl -L "https://www.dropbox.com/download?dl=packages/dropbox.py" -o /usr/bin/dropbox
sudo chmod +x /usr/bin/dropbox

# Download and install Dropbox headless
dropbox update

# Start daemon
dropbox start

# Makes daemon restart on boot
dropbox autostart y
```
