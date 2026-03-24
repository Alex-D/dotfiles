FROM buildpack-deps:noble-curl

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    sudo \
    ssh \
    curl \
    zip unzip \
    procps \
    && apt-get dist-clean

# Rename "ubuntu" user as a generic "dev" user
RUN usermod -md /home/$USERNAME -l $USERNAME ubuntu \
    && groupmod -n $USERNAME ubuntu \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Moby (Docker)
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/moby.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    moby-engine \
    moby-cli \
    moby-buildx \
    moby-compose \
    && apt-get dist-clean

# JetBrains IDEs specific dependencies
# https://www.jetbrains.com/help/idea/prerequisites-for-dev-containers.html#remote_container
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libfreetype6 \
    && apt-get dist-clean

# Latest Git
RUN add-apt-repository ppa:git-core/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
    git \
    && apt-get dist-clean

# Latest GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y --no-install-recommends \
    gh \
    && apt-get dist-clean

# Dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh \
    make \
    gcc \
    g++ \
    python3 \
    gnupg-agent \
    vim \
    tig \
    tree \
    htop \
    postgresql-client \
    && apt-get dist-clean

# Improve zsh setup
COPY scripts/setup-zsh.sh /root/
RUN chmod +x /root/setup-zsh.sh && /root/setup-zsh.sh

WORKDIR /workspace

ENTRYPOINT ["/usr/bin/zsh"]

USER $USERNAME
