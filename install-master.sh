#!/bin/bash
# Script install - node master K8s

#0 - Desactiver la memoire virtuelle (swap)
sudo swapoff -a

#1 - config les packages
echo "[1] config les packages" 
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

#2 - Install containerd
echo "[2] install containerd" 
sudo apt-get update
sudo apt-get install -y curl wget

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update 
sudo apt-get install -y containerd.io

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd

#3- Install les packages Kubernetes - kubeadm, kubelet et kubectl
echo "[3] install - kubeadm, kubelet et kubectl" 
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl containerd

sudo systemctl enable kubelet.service
sudo systemctl enable containerd.service

#4 - Création d'un cluster k8s
# telecharger le manifests calico
echo "[4] Création - Cluster K8s" 
wget https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml

# amorcer le cluster
init_command=$(sudo kubeadm init --apiserver-advertise-address=192.168.56.10  --pod-network-cidr=10.10.0.0/16)

# Extrait le token et le hash de la sortie de la commande kubeadm init
token=$(echo "$init_command" | grep -oP 'kubeadm join .* --token \K[^ ]+')
hash=$(echo "$init_command" | grep -oP '\--discovery-token-ca-cert-hash sha256:\K[^ ]+')

echo "sudo kubeadm join 192.168.56.10:6443 --token $token --discovery-token-ca-cert-hash sha256:$hash" > partage/join-node.sh

#Config notre compte sur le nœud du plan de contrôle pour avoir un accès administratif au serveur API à partir d'un compte non privilégié.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#5 - Création d'un réseau de pods
kubectl apply -f calico.yaml

#6 configurer l'auto complétaion
sudo apt-get install -y bash-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc

echo "[5] install - END" 
