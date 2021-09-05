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

```shell script
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

```shell script
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

```shell script
#!/bin/bash

hostname="alexandredemode.fr"

sudo hostnamectl set-hostname "${hostname}"
echo "127.0.0.1 ${hostname}" | sudo tee -a /etc/hosts

# Note: if the hostname doesn't have a global internet DNS entry, 
# set 127.0.1.1 instead
```


Setup Git
---------

```shell script
#!/bin/bash

email="contact@alex-d.fr"

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

```shell script
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

```shell script
#!/bin/bash

sudo apt update && sudo apt install -y \
    nginx
```


Install Certbot
---------------

[Follow Certbot install instructions](https://certbot.eff.org/lets-encrypt/debianbuster-nginx)



Install PHP-FPM
---------------

```shell script
#!/bin/bash

# Download and add the sury repository gpg key
curl https://packages.sury.org/php/apt.gpg -o /tmp/packages.sury.org.gpg
sudo apt-key add /tmp/packages.sury.org.gpg

# Add sury repository
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list

# Install PHP
php_version="8.0"
sudo apt update && sudo apt install -y \
    unzip \
    php${php_version} \
    php${php_version}-cli \
    php${php_version}-common \
    php${php_version}-fpm \
    php${php_version}-pdo \
    php${php_version}-pdo-mysql \
    php${php_version}-gd \
    php${php_version}-intl \
    php${php_version}-dom \
    php${php_version}-xml
```


Install Composer
----------------

```shell script
#!/bin/zsh

EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
else
    php composer-setup.php --quiet
    sudo mv composer.phar /usr/bin/composer
fi
rm composer-setup.php
```


Install MariaDB
---------------

```shell script
#!/bin/bash

sudo apt update && sudo apt install -y \
    mariadb-server
    
sudo mysql_secure_installation
```


Setup Fail2ban
--------------

```shell script
sudo apt update && sudo apt install -y \
    fail2ban
```

```
# /etc/fail2ban/jail.local

[sshd]
enabled = true

[sshd-ddos]
enabled = true

[recidive]
enabled = true

[nginx-badbots]
enabled = true

[nginx-noproxy]
enabled = true

[nginx-nohome]
enabled = true

[nginx-http-auth]
enabled = true
```


Setup UFW
---------

```shell script
sudo apt update && sudo apt install -y \
    ufw
```

```shell script
#!/bin/zsh

sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow smtp
```


Enable IPv6 on OVH VPS
----------------------

```shell script
#!/bin/zsh

YOUR_IPV6="xxxx:xxxx:xxxx:..."
IPV6_GATEWAY="xxxx:xxxx:xxxx:..."

sudo tee /etc/network/interfaces.d/51-cloud-init-ipv6.cfg > /dev/null <<EOF
auto eth0
iface eth0 inet6 static
mtu 1500
address ${YOUR_IPV6}
netmask 128
post-up /sbin/ip -6 route add ${IPV6_GATEWAY} dev eth0
post-up /sbin/ip -6 route add default via ${IPV6_GATEWAY} dev eth0
pre-down /sbin/ip -6 route del default via ${IPV6_GATEWAY} dev eth0
pre-down /sbin/ip -6 route del ${IPV6_GATEWAY} dev eth0
EOF

sudo systemctl restart networking
```

Source: https://docs.ovh.com/ie/en/vps/configuring-ipv6/


Setup Dropbox Uploader
----------------------

```shell script
#!/bin/zsh

# Download and install Dropbox Uploader
sudo curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o /usr/bin/dropbox_uploader
sudo chmod +x /usr/bin/dropbox_uploader

# First run: follow instructions
dropbox_uploader
```


Setup Backup script
-------------------

First, follow the [Setup Dropbox Uploader](#setup-dropbox-uploader) section.

```shell script
#!/bin/zsh

foldersToBackup="/var/www /etc/nginx/sites-available"
newCron="0 3 * * * $(whoami) $HOME/dev/dotfiles/server/backup.sh $foldersToBackup"
(crontab -l ; echo "$newCron") | crontab -
```


Setup MySQL Backup script
-------------------------

First, follow the [Setup Dropbox Uploader](#setup-dropbox-uploader) section.

```shell script
#!/bin/zsh

mkdir -p ~/.config/backup
cp ~/dev/dotfiles/server/config/mysql ~/.config/backup/mysql
```

Edit `~/.config/backup/mysql` file with user and password.

```shell script
#!/bin/zsh

databaseName="<databaseName>"
newCron="0 3 * * * $(whoami) $HOME/dev/dotfiles/server/mysql_backup.sh $databaseName"
(crontab -l ; echo "$newCron") | crontab -
```

Setup Dropbox Headless
----------------------

```shell script
#!/bin/zsh

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
