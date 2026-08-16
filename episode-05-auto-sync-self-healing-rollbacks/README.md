# Episode 5 – Auto Sync, Self-Healing & Rollbacks

This episode builds on the application created in **Episode 4** 
(`episode-04-deploy-first-application/techops-demo`).

No new application is created in this episode. Instead, we reuse 
the same Argo CD Application (`techops-demo`) and demonstrate how 
Argo CD can automate synchronization, detect and correct configuration 
drift, prune removed resources, and safely roll back changes.

---

## 📺 Video

Watch the full episode here: [Argo CD Auto Sync, Self-Healing & Rollbacks Explained (Ep 5)](https://www.youtube.com/watch?v=GLay2GCwVVY)

---

## 🔗 Application Reference

This episode uses the existing application files from Episode 4:

| File | Purpose |
|------|---------|
| `deployment.yaml` | Defines the `techops-demo` Deployment (replicas: 2) |
| `service.yaml` | Exposes the application via NodePort |
| `configmap.yaml` | Contains the HTML content shown in the browser |

📁 Path: `episode-04-deploy-first-application/techops-demo`

---

## 🧪 What This Episode Covers

- Manual Sync recap
- Enabling Auto Sync
- Enabling Self-Heal
- Enabling Prune
- Configuration Drift detection (manual `kubectl scale`)
- Self-Healing automatic correction
- Pruning demonstration (see `prune-demo.yaml` below)
- Git Rollback using `git revert`
- Argo CD Rollback using `argocd app rollback`

---

## 📁 Files in This Folder

### `prune-demo.yaml`
A temporary ConfigMap used **only** to demonstrate Argo CD's pruning behavior.

**Demo flow:**
1. This file is added to Git and committed.
2. Argo CD (with Auto Sync enabled) automatically creates the ConfigMap in the cluster.
3. The file is then deleted from Git.
4. Because **Prune** is enabled, Argo CD automatically removes the ConfigMap from the cluster as well.

> ⚠️ This file is for **reference only**. It is not part of the live 
> application and was intentionally added and removed during the demo 
> to illustrate pruning behavior. If you want to try it yourself, copy 
> it into your application path, commit, observe sync, then delete it 
> and commit again.

---

## 🛠️ Key Commands Used in This Episode

```bash
# Enable Auto Sync
argocd app set techops-demo --sync-policy automated

# Enable Self-Heal
argocd app set techops-demo --self-heal

# Enable Pruning
argocd app set techops-demo --auto-prune

# Disable Self-Heal temporarily (for drift demo)
argocd app set techops-demo --self-heal=false

# Introduce drift manually
kubectl scale deployment techops-demo -n demo --replicas=7

# View revision history
argocd app history techops-demo

# Roll back to a previous revision
argocd app rollback techops-demo <REVISION_ID>

# Disable Auto Sync (before Argo CD rollback)
argocd app set techops-demo --sync-policy none

# Re-enable Auto Sync
argocd app set techops-demo --sync-policy automated
```

---

## ⏮️ Previous Episode
[Episode 4 – Deploy Your First Application with Argo CD](../episode-04-deploy-first-application)

## ⏭️ Next Episode
[Episode 6 – Managing Helm Applications with Argo CD](../episode-06-managing-helm-applications)
