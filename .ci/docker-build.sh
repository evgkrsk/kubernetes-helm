#/bin/sh

typeset C=centosadmin/kubernetes-helm

I=$(git describe --tags)
[ -z "$I" ] && I=0.0.1

echo "Build $C:$I"

docker build . --tag "$C:latest" --tag "$C:$I"
docker login -u "$docker_hub_login" -p "$docker_hub_password"
docker push "$C:latest"
docker push "$C:$I"
