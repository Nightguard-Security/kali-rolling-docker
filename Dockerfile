FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt -y full-upgrade && \
    apt -y install kali-linux-headless && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt update && \
    apt -y \
        install \
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
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Cuda for GPU
RUN add-apt-repository contrib -y && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb \
    dpkg -i cuda-keyring_1.1-1_all.deb \
    apt update \
    apt -y \
        linux-headers-$(uname -r) \
        nvidia-driver \
        nvidia-cuda-toolkit

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
RUN nvm install

COPY src /
EXPOSE 40022
CMD ["supervisord"]