# 🚀 Istio Traffic Shifting

## ✅ Prerequisites

Before proceeding with traffic shifting, ensure that the **Woof App** 🐶 has been deployed by following the steps mentioned in [this guide](https://github.com/falconcr/istio-ambient-workshop/tree/main/scenarios/waypoint/woof). It is crucial to have both versions (`v1` and `v2`) of the application running in the `woof` namespace.

## 📌 Default HTTPRoute Configuration

In the previous configuration, all traffic was routed to version **v1** of the application using the following **HTTPRoute** manifest:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: woof-route
  namespace: woof
spec:
  parentRefs:
  - kind: Service
    group: ""
    name: woof-service
    port: 80
  rules:
  - backendRefs:
    - name: woof-service-v1
      port: 80
```

## 🔄 Traffic Shifting to Multiple Versions

If we have two versions of the application (`v1` and `v2`), we can use **Istio Traffic Shifting** to distribute traffic as follows:

- **80%** of the traffic goes to `v1` ⚡️
- **20%** of the traffic goes to `v2` 🌟

### 🔧 Updated HTTPRoute Configuration

To achieve this, update the **HTTPRoute** manifest as shown below:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: woof-route
  namespace: woof
spec:
  parentRefs:
  - kind: Service
    group: ""
    name: woof-service
    port: 80
  rules:
  - backendRefs:
    - name: woof-service-v1
      port: 80
      weight: 80
    - name: woof-service-v2
      port: 80
      weight: 20
```

### ℹ️ Explanation

- The **weight** attribute in `backendRefs` determines the percentage of traffic directed to each version.
- `woof-service-v1` gets **80%** of the requests ⚡️.
- `woof-service-v2` gets **20%** of the requests 🌟.
- Istio will handle the distribution automatically without requiring any modifications to the client.

## 🚀 Applying the Configuration

Apply the updated **HTTPRoute** configuration using `kubectl`:

```sh
kubectl apply -f http-route-80-20.yaml
```

## 🔍 Verifying Traffic Distribution

You can test traffic distribution by sending multiple requests and observing responses:

```sh
kubectl -n woof exec curl-app -- bash -c "for i in {1..10}; do curl -si woof-service/woof; echo; sleep 0.5; done"
```

You should see that approximately **80% of requests** go to `v1` ⚡️ and **20% to `v2`** 🌟.

## 🎯 Conclusion

Using **Istio Traffic Shifting**, we can gradually roll out a new version of an application while ensuring stability. This approach allows safe deployment strategies like **canary releases** 🐦 and **A/B testing** 🔬.

