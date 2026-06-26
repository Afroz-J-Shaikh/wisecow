# How to deploy the app on KIND cluster in detail guide

## For deploying app to kind cluster

### Step 1: Clone this repo

### Step 2: Go to setup folder

```bash
chmod +x setup.sh
sudo setup.sh
newgrp docker
kind create cluster --config kind-config.yml
```

### Step 3: Install Envoy Gateway 

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

### Step 4: Install cert-manager

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


### Step 5: Install metrics-server

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

### Step 6: Change DNS name (AWS EC2 instance public DNS)
   - Change DNS name in 40-certificate.yaml to your current DNS name
   - Change DNS name in 50-gateway.yaml(appears 2 times) to your current DNS name

### Step 7: Appy all files in k8s folder

### Step 8: Patch ports
```bash
kubectl patch svc envoy-wisecow-wisecow-gateway-5e20ce84 -n envoy-gateway-system \
  --type='json' \
  -p='[
    {"op":"replace","path":"/spec/ports/0/nodePort","value":30080},
    {"op":"replace","path":"/spec/ports/1/nodePort","value":30443}
  ]'
  ```

## For CI/CD

### Add secrets and variables to your GitHub repo

#### Secrets 
   - DOCKERHUB_TOKEN
   - EC2_HOST
   - EC2_SSH_KEY
   - EC2_USER
#### Variables
   - DOCKERHUB_USER
