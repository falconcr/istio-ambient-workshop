curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH

echo -e "🚀 Installing Kubernetes Gateway... 🔧"

#Note that the Kubernetes Gateway API CRDs do not come installed by default on most Kubernetes clusters, so make sure they are installed before using the Gateway API:
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml; }

echo -e "🛠️ Buckle up! We're installing Istio Ambient... 🧙‍♂️ It's like magic, but with YAML and proxies!"

istioctl install --set profile=ambient --skip-confirmation

echo -e "🤩 Istio ambient configured."

# Install kiali, loki & prometheus
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/loki.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.25/samples/addons/prometheus.yaml
