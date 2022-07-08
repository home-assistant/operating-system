FROM debian:bullseye

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
        graphviz \
        jq \
        make \
        ncurses-dev \
        openssh-client \
        patch \
        perl \
        python3 \
        python3-matplotlib \
        python-is-python3 \
        qemu-utils \
        rsync \
        skopeo \
        sudo \
        unzip \
        vim \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Init entry
COPY scripts/entry.sh /usr/sbin/
ENTRYPOINT ["/usr/sbin/entry.sh"]

# Get buildroot
WORKDIR /build
