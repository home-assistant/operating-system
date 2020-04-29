FROM ubuntu:18.04

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Docker
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        jq \
        gpg-agent \
        software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y --no-install-recommends \
        docker-ce docker-ce-cli containerd.io \
    && rm -rf /var/lib/apt/lists/*

COPY hostapp.sh /usr/bin/
ENTRYPOINT ["/usr/bin/hostapp.sh"]
