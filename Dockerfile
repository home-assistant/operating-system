FROM ubuntu:16.04

# Docker
RUN apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y docker-ce \
    && rm -rf /var/lib/apt/lists/*

# Build Tools
RUN apt-get update && apt-get install -y \
        wget patch vim cpio python python3-pip unzip rsync bc bzip2 ncurses-dev \
        git make g++ file perl bash binutils locales qemu-utils \
    && rm -rf /var/lib/apt/lists/*

#Install VirtualBox
#RUN echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list
#RUN wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
#RUN apt-get update && apt-get install -y \
#        virtualbox-5.0 \
#    && rm -rf /var/lib/apt/lists/*

RUN pip3 install doit

# Init entry
COPY scripts/entry.sh /usr/sbin/
ENTRYPOINT ["/usr/sbin/entry.sh"]

# Get buildroot
WORKDIR /build
