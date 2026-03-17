FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Keep downloaded .deb files so BuildKit cache mounts can reuse them
RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get -y full-upgrade && \
    apt-get -y install kali-linux-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get update && \
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

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get -y install \
    linux-headers-$(dpkg --print-architecture) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get -y install \
    nvidia-driver \
    nvidia-cuda-toolkit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install nvm

RUN mkdir -p /root/.deps

ADD https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh /root/.deps/install.sh

RUN bash /root/.deps/install.sh

RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install node

# Download and cache cudakeyring

ADD https://developer.download.nvidia.com/compute/cuda/repos/debian13/x86_64/cuda-keyring_1.1-1_all.deb /root/.deps/cuda-keyring_1.1-1_all.deb

RUN dpkg -i /root/.deps/cuda-keyring_1.1-1_all.deb && \
    add-apt-repository contrib -y

COPY src /
EXPOSE 40022
CMD ["supervisord"]
