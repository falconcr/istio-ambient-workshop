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

Review `scenarios` folder and enjoy it!