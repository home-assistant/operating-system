FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    wget patch cpio python unzip rsync bc bzip2 ncurses-dev git make g++ python-matplotlib python-numpy

ARG BUILDROOT_VERSION=2017.11.2
ARG BUILDROOT_BOARD=vm

# Get buildroot
WORKDIR /buildroot
RUN wget https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz \
    && tar xvzf buildroot-${BUILDROOT_VERSION}.tar.gz

# Download all the required files
COPY $BUILDROOT_BOARD/buildroot.config /buildroot/buildroot-$BUILDROOT_VERSION/.config
COPY $BUILDROOT_BOARD/linux.config /buildroot/buildroot-$BUILDROOT_VERSION/linux.config
WORKDIR /buildroot/buildroot-$BUILDROOT_VERSION

# CMD /buildroot/buildroot-$BUILDROOT_VERSION/make
