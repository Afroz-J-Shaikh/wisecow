### Step 2: Install Envoy Gateway

```bash
helm repo add envoy-gateway https://gateway.envoyproxy.io/helm-chart
helm repo update

helm install eg envoy-gateway/gateway-helm \
  --namespace envoy-gateway-system \
  --create-namespace \
  --version v1.2.0


# Wait for it to be ready
kubectl wait --namespace envoy-gateway-system \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/name=gateway-helm \
  --timeout=120s
```

### Step 3: Install cert-manager

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

# Wait for it to be ready
kubectl wait --namespace cert-manager \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/instance=cert-manager \
  --timeout=120s
```