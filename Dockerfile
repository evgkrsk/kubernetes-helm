FROM alpine:3.15

# Working packages
ENV PACKAGES curl bash file jq vault upx git gettext
# Update packages to close vulns:
ENV VULN_PACKAGES expat

RUN apk add -u --no-cache $PACKAGES $VULN_PACKAGES && \
    rm -rf /var/cache/apk/ && \
    upx -9 /usr/sbin/vault && \
    :

# https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION 1.23.3
RUN set -ex && \
    curl -sSL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    upx -9 /usr/local/bin/kubectl && \
    :

# rock-solid 1.2 channel: https://raw.githubusercontent.com/werf/werf/multiwerf/trdl_channels.yaml
ENV WERF_VERSION 1.2.55
ENV WERF_HELM3_MODE 1
RUN set -ex && \
    curl -sSL "https://tuf.werf.io/targets/releases/$WERF_VERSION/linux-amd64/bin/werf" -o /usr/local/bin/werf && \
    chmod +x /usr/local/bin/werf && \
    upx -9 /usr/local/bin/werf && \
    :

# https://github.com/helm/helm/releases
ENV HELM_VERSION 3.8.0
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
    helm plugin install https://github.com/databus23/helm-diff --version v3.4.0 && \
    upx -9 /root/.local/share/helm/plugins/helm-diff/bin/diff && \
    helm plugin install https://github.com/jkroepke/helm-secrets --version v3.12.0 && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version v0.10.0 && \
    upx -9 /root/.local/share/helm/plugins/helm-s3.git/bin/helms3 && \
    helm plugin install https://github.com/aslafy-z/helm-git.git --version v0.11.1 && \
    rm -rf /tmp/helm* && rm -rf /root/.cache/helm \
    :

# https://github.com/roboll/helmfile/releases
ENV HELMFILE_VERSION 0.143.0
RUN set -ex && \
    curl -sSL https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 -o /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/helmfile && \
    upx -9 /usr/local/bin/helmfile && \
    :

# https://github.com/kubernetes-sigs/kustomize/releases
ENV KUSTOMIZE_VERSION 4.5.1
RUN set -ex && \
    curl -sSL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz | tar xz && \
    mv kustomize /usr/local/bin/kustomize && \
    upx -9 /usr/local/bin/kustomize && \
    :

CMD ["helm"]
