FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y full-upgrade && \
    apt-get -y install kali-linux-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && \
    apt-get -y install \
        supervisor \
        openssh-server \
        nano \
        vim \
        curl \
        tmux \
        sqlmap \
        nmap \
        cmake \
        libicu-dev \
        htop \
        iputils-ping \
        software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && \
    apt-get -y install \
        linux-headers-$(dpkg --print-architecture) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository contrib -y && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    apt-get update && \
    apt-get -y install \
        nvidia-driver \
        nvidia-cuda-toolkit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install node

COPY src /
EXPOSE 40022
CMD ["supervisord"]