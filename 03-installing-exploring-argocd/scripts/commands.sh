#!/usr/bin/env bash
# ==============================================================================
# Episode 3 – Installing & Exploring Argo CD
# Command reference, in demo order. Not meant to be run blindly end-to-end —
# some steps require manual input (passwords) or editing IP/NodePort values.
# ==============================================================================

# ------------------------------------------------------------------
# Demo 1 – Verify Cluster
# ------------------------------------------------------------------
kubectl get nodes

# ------------------------------------------------------------------
# Demo 2 – Verify Helm
# ------------------------------------------------------------------
helm version

# ------------------------------------------------------------------
# Demo 3 – Add Official Argo CD Repository
# ------------------------------------------------------------------
helm repo add argo https://argoproj.github.io/argo-helm
helm repo list

# ------------------------------------------------------------------
# Demo 4 – Update Helm Repository
# ------------------------------------------------------------------
helm repo update

# ------------------------------------------------------------------
# Demo 5 – Search Available Chart
# ------------------------------------------------------------------
helm search repo argo/argo-cd

# ------------------------------------------------------------------
# Demo 6 – Create Namespace (Optional)
# Helm can also create it automatically with --create-namespace
# ------------------------------------------------------------------
kubectl create namespace argocd
kubectl get ns

# ------------------------------------------------------------------
# Demo 7 – Install Argo CD
# ------------------------------------------------------------------
helm install argocd argo/argo-cd --namespace argocd
# For version pinning:
# helm install argocd argo/argo-cd --namespace argocd --version <chart-version>

# ------------------------------------------------------------------
# Demo 8 – Verify Helm Release
# ------------------------------------------------------------------
helm list -n argocd

# ------------------------------------------------------------------
# Demo 9 – Verify Pods
# ------------------------------------------------------------------
kubectl get pods -n argocd

# ------------------------------------------------------------------
# Demo 10 – Verify Services
# ------------------------------------------------------------------
kubectl get svc -n argocd

# ------------------------------------------------------------------
# Demo 11 – Verify Deployments
# ------------------------------------------------------------------
kubectl get deploy -n argocd

# ------------------------------------------------------------------
# Demo 12 – Verify StatefulSets
# ------------------------------------------------------------------
kubectl get sts -n argocd

# ------------------------------------------------------------------
# Demo 12A – Verify AppProjects
# ------------------------------------------------------------------
kubectl get appprojects -n argocd

# ------------------------------------------------------------------
# Demo 12B – Verify CRDs
# ------------------------------------------------------------------
kubectl get crd | grep argoproj

# ------------------------------------------------------------------
# Demo 13 – Retrieve Initial Admin Password
# ------------------------------------------------------------------
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo

# ------------------------------------------------------------------
# Demo 14 – Access Web UI
# ------------------------------------------------------------------
# Option A: Port forward (temporary)
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0
# Open: https://<your-ip>:8080   (Username: admin | Password: from Demo 13)

# Option B: Expose via NodePort (persistent for local labs)
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort"}}'
kubectl get svc -n argocd
# Open: https://<node-ip>:<node-port>   e.g. https://192.168.56.115:31948/

# ------------------------------------------------------------------
# Demo 16 – Install Argo CD CLI (Linux example)
# ------------------------------------------------------------------
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/
which argocd

# ------------------------------------------------------------------
# Demo 17 – Verify CLI
# ------------------------------------------------------------------
argocd version --client

# ------------------------------------------------------------------
# Demo 18 – CLI Login
# ------------------------------------------------------------------
# Retrieve the password again if needed:
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo

argocd login <node-ip>:<node-port>
# e.g. argocd login 192.168.56.115:31948
# Accept the self-signed cert warning (y), then enter:
#   Username: admin
#   Password: <from above>

# ------------------------------------------------------------------
# Demo 19 – Verify CLI Connection
# ------------------------------------------------------------------
argocd version
argocd account get-user-info

# ------------------------------------------------------------------
# Demo 20 – Change Admin Password
# ------------------------------------------------------------------
argocd account update-password
# Prompts: current password -> new password -> confirm new password

# ------------------------------------------------------------------
# Demo 21 – Delete Initial Admin Secret
# ------------------------------------------------------------------
kubectl get secret -n argocd
kubectl delete secret argocd-initial-admin-secret -n argocd
kubectl get secret -n argocd

# ------------------------------------------------------------------
# Demo 22 – Final Verification
# ------------------------------------------------------------------
helm list -n argocd
kubectl get all -n argocd
