FROM alpine:3.16.3

# Working packages
ENV PACKAGES curl bash file jq vault xz git gettext

SHELL ["/bin/ash", "-xeo", "pipefail", "-c"]

# https://github.com/upx/upx/releases
ENV UPX_VERSION 4.0.2
# hadolint ignore=DL3018
RUN apk upgrade --update-cache --no-cache && \
    apk add --no-cache $PACKAGES && \
    curl -sSL https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-amd64_linux.tar.xz|xzcat | tar x && \
    mv upx-${UPX_VERSION}-amd64_linux/upx /usr/local/bin/upx && \
    file /usr/local/bin/upx |grep statically && \
    chmod +x /usr/local/bin/upx && \
    rm -rf /var/cache/apk/ && \
    upx -9 /usr/sbin/vault && \
    :

# https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION 1.26.1
RUN curl -sSL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    file /usr/local/bin/kubectl|grep statically && \
    chmod +x /usr/local/bin/kubectl && \
    upx -9 /usr/local/bin/kubectl && \
    :

# rock-solid 1.2 channel: https://raw.githubusercontent.com/werf/werf/main/trdl_channels.yaml
# WORKAROUND: https://storage.googleapis.com/werf-tuf/targets/releases/$WERF_VERSION/linux-amd64/bin/werf
ENV WERF_VERSION 1.2.186+fix4
ENV WERF_HELM3_MODE 1
RUN curl --resolve tuf.werf.io:443:54.38.250.137,46.148.230.218,77.223.120.232 -vsSL "https://tuf.werf.io/targets/releases/$WERF_VERSION/linux-amd64/bin/werf" -o /usr/local/bin/werf && \
    file /usr/local/bin/werf |grep statically && \
    chmod +x /usr/local/bin/werf && \
    upx -9 /usr/local/bin/werf && \
    :

# https://github.com/helm/helm/releases
ENV HELM_VERSION 3.11.1
ENV HELM_FILENAME helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN curl -sSL https://get.helm.sh/${HELM_FILENAME} | tar xz && \
    file linux-amd64/helm |grep statically && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 && \
    upx -9 /usr/local/bin/helm && \
    :

ENV HELM_DIFF_COLOR=true
ENV HELM_DIFF_IGNORE_UNKNOWN_FLAGS=true
ENV HELM_DIFF_NORMALIZE_MANIFESTS=true
RUN helm plugin install https://github.com/databus23/helm-diff --version v3.6.0 && \
    upx -9 /root/.local/share/helm/plugins/helm-diff/bin/diff && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version v4.2.2 && \
    rm -rf /root/.local/share/helm/plugins/helm-secrets/.git && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version v0.14.0 && \
    upx -9 /root/.local/share/helm/plugins/helm-s3.git/bin/helm-s3 && \
    rm -rf /root/.local/share/helm/plugins/helm-s3.git/.git && \
    rm -rf /root/.local/share/helm/plugins/helm-s3.git/releases && \
    helm plugin install https://github.com/aslafy-z/helm-git.git --version v0.14.3 && \
    helm plugin install https://github.com/marckhouzam/helm-fullstatus --version v0.3.0 && \
    rm -rf /tmp/helm* && rm -rf /root/.cache/helm && \
    :

# https://github.com/helmfile/helmfile/releases
ENV HELMFILE_VERSION 0.150.0
RUN curl -sSL https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz | tar xz && \
    file helmfile |grep statically && \
    mv helmfile /usr/local/bin/helmfile && \
    upx -9 /usr/local/bin/helmfile && \
    :

# https://github.com/kubernetes-sigs/kustomize/releases
ENV KUSTOMIZE_VERSION 5.0.0
RUN curl -sSL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz | tar xz && \
    file kustomize |grep statically && \
    mv kustomize /usr/local/bin/kustomize && \
    upx -9 /usr/local/bin/kustomize && \
    :

# https://github.com/variantdev/vals/releases
ENV VALS_VERSION 0.21.0
RUN curl -sSL https://github.com/variantdev/vals/releases/download/v${VALS_VERSION}/vals_${VALS_VERSION}_linux_amd64.tar.gz | tar xz && \
    file vals |grep statically && \
    mv vals /usr/local/bin/vals && \
    upx -9 /usr/local/bin/vals && \
    :

CMD ["helm"]
