# Episode 3 – Command Reference

All commands used in the demo, in order. These are meant to be copy-pasted **one at a time** while following along — not run as a single script, since some steps need manual input (passwords) or values specific to your environment (IP address, NodePort).

---

## Demo 1 – Verify Cluster
```bash
kubectl get nodes
```
All nodes should show `STATUS: Ready`.

## Demo 2 – Verify Helm
```bash
helm version
```

## Demo 3 – Add the Official Argo CD Repository
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo list
```

## Demo 4 – Update Helm Repository
```bash
helm repo update
```

## Demo 5 – Search Available Chart
```bash
helm search repo argo/argo-cd
```

## Demo 6 – Create Namespace (Optional)
> Helm can also create it automatically with `--create-namespace`.
```bash
kubectl create namespace argocd
kubectl get ns
```

## Demo 7 – Install Argo CD
```bash
helm install argocd argo/argo-cd --namespace argocd
```
For version pinning:
```bash
helm install argocd argo/argo-cd --namespace argocd --version <chart-version>
```

## Demo 8 – Verify Helm Release
```bash
helm list -n argocd
```

## Demo 9 – Verify Pods
```bash
kubectl get pods -n argocd
```
Every pod should be `Running` and `1/1`.

## Demo 10 – Verify Services
```bash
kubectl get svc -n argocd
```

## Demo 11 – Verify Deployments
```bash
kubectl get deploy -n argocd
```

## Demo 12 – Verify StatefulSets
```bash
kubectl get sts -n argocd
```

## Demo 12A – Verify AppProjects
```bash
kubectl get appprojects -n argocd
```

## Demo 12B – Verify CRDs
```bash
kubectl get crd | grep argoproj
```

## Demo 13 – Retrieve Initial Admin Password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

## Demo 14 – Access Web UI

**Option A — Port Forward (temporary)**
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0
```
Open `https://<your-ip>:8080` — Username: `admin`, Password: from Demo 13.

**Option B — Expose via NodePort (persistent, for local labs)**
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort"}}'
kubectl get svc -n argocd
```
Open `https://<node-ip>:<node-port>` — e.g. `https://192.168.56.115:31948/`

## Demo 16 – Install Argo CD CLI (Linux example)
```bash
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/
which argocd
```

## Demo 17 – Verify CLI
```bash
argocd version --client
```

## Demo 18 – CLI Login
```bash
# Retrieve the password again if needed:
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo

argocd login <node-ip>:<node-port>
# e.g. argocd login 192.168.56.115:31948
```
Accept the self-signed cert warning (`y`), then enter:
- Username: `admin`
- Password: *(from above)*

## Demo 19 – Verify CLI Connection
```bash
argocd version
argocd account get-user-info
```

## Demo 20 – Change Admin Password
```bash
argocd account update-password
```
Prompts: current password → new password → confirm new password.

## Demo 21 – Delete Initial Admin Secret
```bash
kubectl get secret -n argocd
kubectl delete secret argocd-initial-admin-secret -n argocd
kubectl get secret -n argocd
```

## Demo 22 – Final Verification
```bash
helm list -n argocd
kubectl get all -n argocd
```
