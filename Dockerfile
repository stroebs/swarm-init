FROM alpine:3.8
MAINTAINER Github: stroebs

ARG DOCKERVERSION=18.06.1-ce

WORKDIR /

RUN apk add --update \
    jq \
    python \
    py-pip && \
    pip install --upgrade pip && \
    pip install --upgrade --no-cache-dir awscli && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

ADD https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKERVERSION.tgz .

RUN tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
    -C /usr/local/bin docker/docker

COPY init-entry.sh /

CMD ["/init-entry.sh"]
