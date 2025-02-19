# 🐶 Woof App - Waypoint

## Introduction

Woof App utilizes **Istio Waypoint**, a concept introduced in **Istio Ambient Mesh**, which provides a **lightweight and efficient alternative** to the traditional sidecar-based service mesh.

Waypoints act as **per-service proxies** that offer **Layer 7 (L7) capabilities** such as **authorization, telemetry, and policy enforcement**—all without requiring a sidecar on every workload.

---

## 🚀 Deployment Steps

### 1️⃣ Install Gateway API

Ambient mesh is configured using the Gateway API. The APIs are not installed by default on most clusters, so install the latest version:

[Gateway API Documentation](https://gateway-api.sigs.k8s.io/)

```sh
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml }
```

### 2️⃣ Create the Namespace

First, create the **namespace** and enable **Istio Ambient Mode**:

```sh
kubectl create -f namespace.yaml
kubectl label ns woof istio.io/dataplane-mode=ambient
```

### 3️⃣ Deploy the Test Application

```sh
kubectl apply -f curl-app.yaml
```

### 4️⃣ Create a Waypoint in the `woof` Namespace

You can create a **waypoint** in two different ways:

#### Option 1: Using `istioctl`
```sh
istioctl waypoint generate --for service -n woof | kubectl apply -f -
```

#### Option 2: Using a YAML Manifest
```sh
kubectl apply -f gateway.yaml
```

### 5️⃣ Label the Namespace to Use the Waypoint

```sh
kubectl label ns woof istio.io/use-waypoint=waypoint
```

### 6️⃣ Deploy the Woof App and Services

```sh
kubectl apply -f woof-app.yaml -f woof-service.yaml
```

### 7️⃣ Create HTTP Routes

```sh
kubectl apply -f http-route.yaml
```

### 8️⃣  Create a pod to access the service

To test the newly configured routes, deploy a **test pod**:

```sh
kubectl apply -f curl-app.yaml
```

### 9️⃣ Test the service

To test the configured routes, use the following command:

```sh
kubectl exec curl-app -- curl -i http://woof-service/woof
```

---

Your **Woof App** is now deployed with **Istio Ambient Mesh** and **Waypoint proxying** enabled.

