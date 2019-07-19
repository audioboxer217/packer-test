FROM mesosphere/aws-cli

ENV packer_ver 1.4.2
WORKDIR /usr/local/bin
RUN apk add --update unzip ca-certificates wget \
    && wget --no-check-certificate https://releases.hashicorp.com/packer/${packer_ver}/packer_${packer_ver}_linux_amd64.zip \
    && unzip packer_${packer_ver}_linux_amd64.zip \
    && rm packer_${packer_ver}_linux_amd64.zip \
    && apk del unzip wget \
    && rm -rf /var/cache/apk/*

ENTRYPOINT /bin/sh
