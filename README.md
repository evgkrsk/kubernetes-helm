# kubernetes-helm

[![Docker Pulls](https://img.shields.io/docker/pulls/evgkrsk/kubernetes-helm.svg)]()
[![Docker Automated buil](https://img.shields.io/docker/automated/evgkrsk/kubernetes-helm.svg)]()
[![Docker Build Statu](https://img.shields.io/docker/build/evgkrsk/kubernetes-helm.svg)]()

Image providing [kubernetes](http://kubernetes.io/) tools `kubectl`,
`helm`, `helmfile`, `kustomize`, `werf`.

## Supported tags and respective `Dockerfile` links

- `latest` [Dockerfile](https://github.com/evgkrsk/kubernetes-helm/blob/master/Dockerfile)


## Overview

The main purpose of this image is to use it in CI pipelines, e.g. to deploy an
application using `helm`.

For example, for [Gitlab CI](https://about.gitlab.com/features/gitlab-ci-cd/):

```yaml
...

deploy-staging:
  image: evgkrsk/kubernetes-helm
  stage: deploy
  before_script:
    - kubectl config set-cluster ${KUBE_NAME}
    - kubectl config set-credentials ${KUBE_USER}
    - kubectl config set-context ${KUBE_NAME}
        --cluster="${KUBE_NAME}"
        --user="${KUBE_USER}"
        --namespace="${KUBE_NAMESPACE}"
    - kubectl config use-context ${KUBE_NAME}
  script:
    - helm install release-name chart/name --namespace ${KUBE_NAMESPACE}

...
```

## License

[MIT](https://github.com/evgkrsk/kubernetes-helm/blob/master/LICENSE).
