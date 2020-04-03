FROM alpine:3.6
LABEL maintainer="Sergey Bondarev <s.bondarev@southbridge.ru>"

ENV KUBECTL_VERSION v1.16.8
ENV HELM_VERSION 3.1.2
ENV MULTIWERF_VERSION 1.2.3
ENV HELM_FILENAME helm-v${HELM_VERSION}-linux-amd64.tar.gz

RUN apk add --no-cache --virtual .deps curl bash

RUN set -ex \
    && curl -sSL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN set -ex \
    && curl -sSL https://get.helm.sh/${HELM_FILENAME} | tar xz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64

RUN set -ex \
    && curl -sSL https://github.com/flant/multiwerf/releases/download/v{MULTIWERF_VERSION}/multiwerf-linux-amd64-v{MULTIWERF_VERSION} -o /usr/local/bin/multiwerf \
    && chmod +x /usr/local/bin/multiwerf

CMD ["helm"]
