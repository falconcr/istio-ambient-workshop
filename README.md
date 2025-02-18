# Kubernetes Cluster with Kind and Istio Ambient
## Prerequisites
Before starting, make sure you have the following tools installed:

- Docker: Needed for creating Kubernetes clusters with Kind.
- Kind: A tool for running Kubernetes clusters in Docker containers.
- kubectl: Kubernetes command-line tool to interact with the cluster.
- Istioctl: Command-line tool to install and manage Istio.

## Setup

- Run `kind create cluster --name istio-ambient-cluster --image kindest/node:v1.28.0 --config kind/kind-config.yaml` to create the cluster.

- Give the execution permision to the script. Run `chmod +x istio/install-istio.sh`

- Verify the control plane components with:
```
kubectl get pods -n istio-system
```

    You should see pods for Ambient Mesh components like:

    - ztunnel: Handles ambient data plane traffic.
    - istiod (optional, depending on your setup): Istio control plane.

## Scenarios

### Implementing L4 Authorization with ztunnel

- Enable Ambient mesh in a namespace

`kubectl label namespace default istio.io/dataplane-mode=ambient`

- Deploy Nginx and Sleep Pods

```
kubectl apply -f https://k8s.io/examples/application/deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.20/samples/sleep/sleep.yaml
```

- Run the following command to create the nginx service:

```
kubectl apply -f scenarios/authorization-ztunel-l4/nginx-service.yaml
```

- Restricting access to nginx
`cat scenarios/authorization-ztunel-l4/authorization-policy.yaml`

- Apply the authorization resource

`kubectl apply -f scenarios/authorization-ztunel-l4/authorization-policy.yaml`

## Validate Restriction
✅ sleep pod should access Nginx.

```
kubectl exec deploy/sleep -- curl -s http://nginx-service.default.svc.cluster.local
```

❌ Other pods should be denied.

```
kubectl run testpod --image=busybox -- sleep 3600
kubectl exec testpod -- wget -qO- http://nginx-service.default.svc.cluster.local
```