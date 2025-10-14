# Lấy token thật từ ServiceAccount dev-sa
TOKEN=$(kubectl create token dev-sa -n dev)

# Tạo kubeconfig mới
KUBECONFIG_FILE=/home/namnv/IdeaProjects/infra-ansible-final/k8s/k8s_rbac_multiuser/dev-sa.kubeconfig

kubectl config set-cluster sa-cluster \
  --server=https://192.168.56.10:6443 \
  --certificate-authority=111 \
  --kubeconfig=$KUBECONFIG_FILE

kubectl config set-credentials dev-sa \
  --token=$TOKEN \
  --kubeconfig=$KUBECONFIG_FILE

kubectl config set-context dev-sa-context \
  --cluster=sa-cluster --namespace=dev --user=dev-sa \
  --kubeconfig=$KUBECONFIG_FILE

kubectl config use-context dev-sa-context --kubeconfig=$KUBECONFIG_FILE

kubectl --kubeconfig=$KUBECONFIG_FILE get pods -n dev
