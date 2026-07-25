# Episode 3 – Installing & Exploring Argo CD

Part of the **GitOps with Argo CD** series.

> Previous: [Episode 2 – Organizing a Git Repository for GitOps](../episode-02-repository-structure)
> Next: [Episode 4 – Deploying Your First Application with Argo CD](../episode-04-deploy-first-application/)

## Overview

In this episode we cover the Argo CD architecture, compare installation methods, install Argo CD using Helm, access the Web UI and CLI, and complete initial security configuration (password change + cleanup of the initial admin secret).

By the end of this episode you will have:
- A working Argo CD installation on Kubernetes
- Access to the Argo CD Web UI (via port-forward and NodePort)
- The Argo CD CLI installed and authenticated
- A secured admin account (default password changed, initial secret deleted)

## Learning Objectives

- Understand the Argo CD architecture and core components
- Compare Argo CD installation methods (YAML manifests, Helm, Operator, GitOps Bootstrap)
- Install Argo CD using the official Helm chart
- Access the Web UI, retrieve the initial admin password, and log in
- Install and use the Argo CD CLI
- Explore the dashboard (Applications, Projects, Repositories, Clusters, Settings)
- Apply initial security best practices

## Argo CD Architecture

| Component | Type | Purpose |
|---|---|---|
| API Server | Deployment | Entry point for Web UI/CLI, handles auth and app operations |
| Repository Server | Deployment | Connects to Git repos, generates manifests (Helm/Kustomize/YAML) |
| Application Controller | StatefulSet | Compares desired (Git) vs live (cluster) state and syncs |
| Redis | Deployment/StatefulSet | Caching layer for performance |
| ApplicationSet Controller *(optional)* | Deployment | Manages multiple Applications automatically |
| Dex Server *(optional)* | Deployment | SSO integration (LDAP, GitHub, GitLab, OIDC) |
| Notifications Controller *(optional)* | Deployment | Sends alerts (Slack, Teams, email, webhooks) |

CRDs created: `applications.argoproj.io`, `applicationsets.argoproj.io`, `appprojects.argoproj.io`

## Installation Methods Compared

| Method | Best For |
|---|---|
| Official YAML manifests | Learning/testing; manual upgrades |
| **Helm chart (used in this series)** | Simplicity + flexibility + easy upgrades/rollbacks |
| Argo CD Operator | Enterprise / OpenShift, automated lifecycle mgmt |
| GitOps Bootstrap | Advanced — Argo CD manages itself from Git |

## Demo Environment

- **Kubernetes Cluster:** kubeadm
- **Control Plane:** 1 node (4 vCPU / 4 GB RAM)
- **Worker Nodes:** 2 nodes (2 vCPU / 2 GB RAM each)
- **Container Runtime:** containerd
- **Prerequisites:** Helm installed, kubectl configured, Git installed

## Prerequisites

- A running Kubernetes cluster (kubeadm, kind, minikube, EKS/GKE/AKS, etc.)
- [Helm 3.x](https://helm.sh/docs/intro/install/) installed
- `kubectl` configured to talk to your cluster
- Cluster admin permissions (to create namespaces, CRDs, RBAC)

## Quick Start

```bash
# 1. Add the Argo CD Helm repo
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# 2. Create namespace
kubectl create namespace argocd

# 3. Install Argo CD
helm install argocd argo/argo-cd --namespace argocd

# 4. Verify
helm list -n argocd
kubectl get pods -n argocd
```

Full step-by-step commands (with explanations) are in [`docs/commands.md`](docs/commands.md).

## Accessing the Web UI

**Option A — Port Forward (quick, temporary)**
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0
```
Open `https://<your-ip>:8080` (accept the self-signed cert warning).

**Option B — NodePort (persistent, for local labs)**
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"NodePort"}}'
kubectl get svc -n argocd
```
Open `https://<node-ip>:<node-port>`

**Login:**
- Username: `admin`
- Password:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d && echo
  ```

## Argo CD CLI

```bash
# Download (Linux example)
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd
sudo mv argocd /usr/local/bin/

# Verify
argocd version --client

# Login
argocd login <node-ip>:<node-port>

# Verify connection
argocd version
argocd account get-user-info
```

## Security Best Practices Covered

- [x] Change the default `admin` password immediately after first login
  ```bash
  argocd account update-password
  ```
- [x] Delete the `argocd-initial-admin-secret` once the password is changed
  ```bash
  kubectl delete secret argocd-initial-admin-secret -n argocd
  ```
- [ ] Consider enabling SSO (GitHub, Azure AD, Okta, LDAP) for production
- [ ] Disable the local admin account once SSO is fully adopted
- [ ] Audit login activity and configuration changes

## Verification Checklist

| Check | Command |
|---|---|
| Nodes ready | `kubectl get nodes` |
| Helm release deployed | `helm list -n argocd` |
| Pods running (1/1) | `kubectl get pods -n argocd` |
| Services (ClusterIP/NodePort) | `kubectl get svc -n argocd` |
| Deployments available | `kubectl get deploy -n argocd` |
| StatefulSet (Application Controller) ready | `kubectl get sts -n argocd` |
| Default AppProject exists | `kubectl get appprojects -n argocd` |
| CRDs installed | `kubectl get crd \| grep argoproj` |
| All resources | `kubectl get all -n argocd` |

## Folder Structure

```
03-installing-exploring-argocd/
├── README.md              # This file
└── docs/
    └── commands.md         # All CLI commands from the demo, in order (reference only)
```

## Next Episode

In **Episode 4**, we'll connect Argo CD to a Git repository and deploy our first application using GitOps.

## Feedback

If this helped, please ⭐ the repo, and feel free to open an issue with questions or corrections.
