### Step 2: Install Envoy Gateway

```bash
helm install eg oci://docker.io/envoyproxy/gateway-helm \
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


## 4. Install metrics-server

HPA needs real CPU/memory numbers. Without this, `kubectl top` and autoscaling won't work.

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Kind uses self-signed certs, so metrics-server can't verify kubelet TLS — patch it:

```bash
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```

Wait for it to be ready:

```bash
kubectl rollout status deployment/metrics-server -n kube-system --timeout=120s
```