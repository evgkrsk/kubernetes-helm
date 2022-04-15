FROM alpine:3.15.4
RUN cat /etc/resolv.conf
ENV PACKAGES curl bind-tools
RUN set -ex && \
    apk upgrade --update-cache --no-cache && \
    apk add --no-cache $PACKAGES && \
    rm -rf /var/cache/apk/ && \
    :
ENV WERF_VERSION 1.2.71
ENV WERF_HELM3_MODE 1
RUN host -4 tuf.werf.io
RUN set -ex && \
    curl --ipv4 -vsSL "https://tuf.werf.io/targets/releases/$WERF_VERSION/linux-amd64/bin/werf" -o /usr/local/bin/werf && \
    chmod +x /usr/local/bin/werf && \
    :
