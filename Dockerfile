FROM alpine:3.7


RUN apk add --no-cache \
    wget patch vim cpio python unzip rsync bc bzip2 ncurses-dev \
    git make g++ file perl bash binutils

# Get buildroot
WORKDIR /build
