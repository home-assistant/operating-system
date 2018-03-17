FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    wget patch vimp cpio python unzip rsync bc bzip2 ncurses-dev \
    git make g++ python-matplotlib python-numpy graphviz

# Get buildroot
WORKDIR /build
COPY . /build
