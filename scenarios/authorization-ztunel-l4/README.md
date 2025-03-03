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