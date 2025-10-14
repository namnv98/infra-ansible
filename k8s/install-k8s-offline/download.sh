#!/bin/bash
set -euo pipefail

#!/bin/bash
set -euo pipefail


K8S_VERSION="1.34.1"             # https://cdn.dl.k8s.io/release/stable.txt
CNI_PLUGINS_VERSION="1.8.0"      # https://github.com/containernetworking/plugins/releases
CRICTL_VERSION="1.34.0"          # https://github.com/kubernetes-sigs/cri-tools/releases
CONTAINERD_VERSION="2.1.3"       # https://github.com/containerd/containerd/releases
RUNC_VERSION="1.3.0"             # https://github.com/opencontainers/runc/releases
KUBE_RELEASE_VERSION="0.18.0"    # https://github.com/kubernetes/release/releases
CALICO_VERSION="3.29.6"          # https://github.com/projectcalico/calico/releases

mkdir -p setup && cd setup

# ===============================
# CNI plugins
# ===============================
wget https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz
mv cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz cni-plugins-linux-amd64.tgz

# ===============================
# CRI tools
# ===============================
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRICTL_VERSION}/crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz
mv crictl-v${CRICTL_VERSION}-linux-amd64.tar.gz crictl-linux-amd64.tar.gz

# ===============================
# Kubernetes binaries
# ===============================
wget https://dl.k8s.io/release/v${K8S_VERSION}/bin/linux/amd64/kubeadm
wget https://dl.k8s.io/release/v${K8S_VERSION}/bin/linux/amd64/kubelet
wget https://dl.k8s.io/release/v${K8S_VERSION}/bin/linux/amd64/kubectl

# ===============================
# kubelet & kubeadm systemd configs
# ===============================
wget https://raw.githubusercontent.com/kubernetes/release/v${KUBE_RELEASE_VERSION}/cmd/krel/templates/latest/kubelet/kubelet.service
wget https://raw.githubusercontent.com/kubernetes/release/v${KUBE_RELEASE_VERSION}/cmd/krel/templates/latest/kubeadm/10-kubeadm.conf

# ===============================
# Containerd
# ===============================
wget https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
mv containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz containerd-linux-amd64.tar.gz

wget https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64
wget https://raw.githubusercontent.com/containerd/containerd/v${CONTAINERD_VERSION}/containerd.service

# ===============================
# Calico CNI
# ===============================
wget https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/calico.yaml

echo "Download binaries completed in $(pwd)"