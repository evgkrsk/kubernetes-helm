FROM alpine:3.16.0

# Working packages
ENV PACKAGES curl bash file jq vault upx git gettext

RUN set -ex && \
    apk upgrade --update-cache --no-cache && \
    apk add --no-cache $PACKAGES && \
    rm -rf /var/cache/apk/ && \
    upx -9 /usr/sbin/vault && \
    :

# https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION 1.24.2
RUN set -ex && \
    curl -sSL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    upx -9 /usr/local/bin/kubectl && \
    :

# rock-solid 1.2 channel: https://raw.githubusercontent.com/werf/werf/multiwerf/trdl_channels.yaml
# WORKAROUND: https://storage.googleapis.com/werf-tuf/targets/releases/$WERF_VERSION/linux-amd64/bin/werf
ENV WERF_VERSION 1.2.80
ENV WERF_HELM3_MODE 1
RUN set -ex && \
    curl --resolve tuf.werf.io:443:54.38.250.137,46.148.230.218,77.223.120.232 -vsSL "https://tuf.werf.io/targets/releases/$WERF_VERSION/linux-amd64/bin/werf" -o /usr/local/bin/werf && \
    chmod +x /usr/local/bin/werf && \
    upx -9 /usr/local/bin/werf && \
    :

# https://github.com/helm/helm/releases
ENV HELM_VERSION 3.9.0
ENV HELM_FILENAME helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN set -ex && \
    curl -sSL https://get.helm.sh/${HELM_FILENAME} | tar xz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 && \
    upx -9 /usr/local/bin/helm && \
    :

ENV HELM_DIFF_COLOR=true
ENV HELM_DIFF_IGNORE_UNKNOWN_FLAGS=true
RUN set -ex && \
    helm plugin install https://github.com/databus23/helm-diff --version v3.5.0 && \
    upx -9 /root/.local/share/helm/plugins/helm-diff/bin/diff && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version v3.14.0 && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version v0.12.0 && \
    upx -9 /root/.local/share/helm/plugins/helm-s3.git/bin/helms3 && \
    helm plugin install https://github.com/aslafy-z/helm-git.git --version v0.11.2 && \
    helm plugin install https://github.com/marckhouzam/helm-fullstatus --version v0.3.0 && \
    rm -rf /tmp/helm* && rm -rf /root/.cache/helm \
    :

ENV HELMFILE_VERSION 0.145.0
RUN set -ex && \
    curl -sSL https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz | tar xz && \
    mv helmfile /usr/local/bin/helmfile && \
    upx -9 /usr/local/bin/helmfile && \
    :

# https://github.com/kubernetes-sigs/kustomize/releases
ENV KUSTOMIZE_VERSION 4.5.5
RUN set -ex && \
    curl -sSL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz | tar xz && \
    mv kustomize /usr/local/bin/kustomize && \
    upx -9 /usr/local/bin/kustomize && \
    :

CMD ["helm"]
