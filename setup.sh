#!/bin/bash
set -euo pipefail

if [ $EUID -ne 0 ];then
       	echo "This script must be run as root";
	exit 1
else
	echo "Running as root"
fi

# Check if docker command exists
if ! command -v docker &> /dev/null
then
    echo "Installing Docker............"
    apt update
    apt install -y ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    usermod -aG docker ubuntu
else
    echo "Docker already installed"
fi

# Check if kind command exists
if ! command -v kind &> /dev/null
then
    echo "Installing kind.........."
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
    chmod +x ./kind
    mv ./kind /usr/local/bin/kind
else
    echo "kind is installed."
fi

# Check if kubectl command exists
if ! command -v kubectl &> /dev/null
then
    echo "Installing kubectl.........."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl
else
    echo "kubectl is installed."
fi

# Check if helm command exists
if ! command -v helm &> /dev/null
then
    echo "Installing helm.........."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    echo "helm is installed."
fi


echo "===Docker version==="
docker --version
echo "===Kind version==="
kind --version
echo "===Kubectl version==="
kubectl version --client
echo "===helm version==="
helm version


