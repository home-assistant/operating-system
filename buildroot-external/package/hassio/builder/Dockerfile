FROM alpine:3.7

# Install packages
RUN apk add --no-cache \
        bash
RUN apk add --no-cache --repository http://nl.alpinelinux.org/alpine/v3.7/community \
        docker

COPY hostapp.sh /usr/bin/
ENTRYPOINT ["/usr/bin/hostapp.sh"]
