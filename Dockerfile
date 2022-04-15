FROM alpine:3.15.4
RUN cat /etc/resolv.conf
RUN ping -c 1 tuf.werf.io
ENV PACKAGES curl
RUN set -ex && \
    apk upgrade --update-cache --no-cache && \
    apk add --no-cache $PACKAGES && \
    rm -rf /var/cache/apk/ && \
    :
ENV WERF_VERSION 1.2.71
ENV WERF_HELM3_MODE 1
RUN set -ex && \
    curl -vsSL "https://tuf.werf.io/targets/releases/$WERF_VERSION/linux-amd64/bin/werf" -o /usr/local/bin/werf && \
    chmod +x /usr/local/bin/werf && \
    :
