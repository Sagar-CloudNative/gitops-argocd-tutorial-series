# Episode 6 – Managing Helm Applications with Argo CD

This episode introduces a **new Helm chart** (`nginx-demo`) and shows how Argo CD
manages Helm applications as part of a GitOps workflow — including configuring
values, overriding them through Argo CD, and upgrading the application via Git.

---

## 📺 Video

Watch the full episode here: https://www.youtube.com/watch?v=VbL7p8UM-qE

---

## 🧪 What This Episode Covers

- Why use Helm with Argo CD
- How Argo CD renders Helm charts (no `helm install` / `helm upgrade` involved)
- Helm chart structure: `Chart.yaml`, `values.yaml`, `templates/`
- Helm chart sources: Git repository vs Helm repository
- `values.yaml` vs Helm parameters — when to use each
- Overriding a Helm value through the Argo CD Application (`--helm-set`)
- Upgrading a Helm application via Git (image tag change)
- Best practices for Helm + Argo CD

---

## 📁 Files in This Folder

### `helm/nginx-demo/`
A Helm chart for the NGINX demo application, generated with `helm create` and
trimmed down for this episode.

| File | Purpose |
|------|---------|
| `Chart.yaml` | Chart metadata (name, version, appVersion) |
| `values.yaml` | Default configuration — replica count, image, service type |
| `templates/deployment.yaml` | Deployment template |
| `templates/service.yaml` | Service template |
| `templates/serviceaccount.yaml` | ServiceAccount template |
| `templates/ingress.yaml`, `hpa.yaml`, `httproute.yaml` | Optional resources (not used in this demo, kept as chart defaults) |
| `templates/_helpers.tpl` | Shared template helpers |
| `templates/tests/test-connection.yaml` | Helm test hook |

### `argocd/nginx-demo-app.yaml`
The Argo CD Application manifest that points to the Helm chart above and
deploys it into the `demo` namespace.

📁 Path: `episode-06-managing-helm-applications/helm/nginx-demo`

---

## 🛠️ Key Commands Used in This Episode

```bash
# Create the chart
helm create nginx-demo

# Validate the chart
helm lint .

# Preview rendered manifests locally
helm template nginx-demo .

# Apply the Argo CD Application
kubectl apply -f episode-06-managing-helm-applications/argocd/nginx-demo-app.yaml

# Sync the application
argocd app sync nginx-demo

# Override a Helm value (replicaCount 2 → 5)
argocd app set nginx-demo --helm-set replicaCount=5

# Check the rendered manifest before syncing
argocd app manifests nginx-demo | grep -A2 "replicas:"

# Verify the app status
argocd app get nginx-demo

# Upgrade: after changing image.tag in values.yaml and pushing to Git
argocd app sync nginx-demo
kubectl rollout status deployment/nginx-demo -n demo
```

---

## ⚠️ Note on Chart State

`values.yaml` in this folder reflects the **starting configuration** used for
recording (`replicaCount: 2`, `image.tag: "1.27"`). During the episode, this
gets overridden to `replicaCount: 5` via an Argo CD parameter, and upgraded to
`image.tag: "1.28"` via a Git commit — both demonstrated live. If you're
following along, start from this file as-is.

---

## ⏮️ Previous Episode
[Episode 5 – Auto Sync, Self-Healing & Rollbacks](../episode-05-auto-sync-self-healing-rollbacks)

## ⏭️ Next Episode
Episode 7 – Argo CD Image Updater (coming soon)
