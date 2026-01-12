FROM ubuntu:22.04

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        ca-certificates \
        git \
        wget \
        curl \
        mariadb-client \
        unzip && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["sleep", "infinity"]