#!/bin/bash

set -e

docker >/dev/null 2>&1 || echo "Docker must be installed"
kubectl >/dev/null 2>&1 || echo "kubectl must be installed"
consul >/dev/null 2>&1 || echo "consul cli must be installed"
kind >/dev/null 2>&1 || echo "Kind must be installed https://kind.sigs.k8s.io/docs/user/quick-start/#installation"
helm >/dev/null 2>&1 || echo "Helm must be installed https://helm.sh/docs/intro/quickstart/"
echo "Creating kind k8s cluster"
kind create cluster --config kind.yaml || true

echo "Installing consul with helm chart"
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/consul
helm install consul hashicorp/consul --set global.name=consul --values values.yaml --wait || true

echo "Building spring boot container image"
cd spring-app
./gradlew clean bootBuildImage
cd ../

echo "loading image in kind k8s cluster"
kind load docker-image docker.io/library/consul:0.0.1-SNAPSHOT

pkill kubectl || true
kubectl port-forward consul-server-0 8500 &
sleep 2
consul kv put spring-configs/test/data "message: Hello World"
# stoppping port forward
pkill kubectl

echo "deploying spring boot app"
kubectl apply -f deployment.yaml
kubectl wait --for=condition=available --timeout=60s deployment/spring-app


