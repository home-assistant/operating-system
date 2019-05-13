FROM alpine:3.9

# Install packages
RUN apk add --no-cache \
    bash coreutils e2fsprogs curl
RUN apk add --no-cache --repository http://nl.alpinelinux.org/alpine/v3.7/community \
    docker

COPY hostapp.sh /usr/bin/
ENTRYPOINT ["/usr/bin/hostapp.sh"]
