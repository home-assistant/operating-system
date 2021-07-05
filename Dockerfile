FROM debian:buster

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Docker
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gpg-agent \
        gpg \
        dirmngr \
        software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y --no-install-recommends \
        docker-ce \
    && rm -rf /var/lib/apt/lists/*

# Build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        bc \
        binutils \
        build-essential \
        bzip2 \
        cpio \
        file \
        git \
        make \
        ncurses-dev \
        patch \
        perl \
        python \
        python-matplotlib \
        graphviz \
        rsync \
        sudo \
        unzip \
        zip \
        wget \
        qemu-utils \
        openssh-client \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Init entry
COPY scripts/entry.sh /usr/sbin/
ENTRYPOINT ["/usr/sbin/entry.sh"]

# Get buildroot
WORKDIR /build
