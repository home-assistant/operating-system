FROM ubuntu:16.04


RUN apt-get update && apt-get install -y \
    wget patch vim cpio python unzip rsync bc bzip2 ncurses-dev \
    git make g++ file perl bash binutils locales qemu-utils

# Get buildroot
WORKDIR /build
