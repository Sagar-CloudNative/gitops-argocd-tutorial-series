# Episode 4 – Deploy Your First Application with Argo CD

## Overview

This directory contains the Kubernetes manifests used in **Episode 4** of the
**GitOps + Argo CD** tutorial series by **TechOps Tutorials**.

In this episode you'll learn how to:

- Create an Argo CD `Application` resource
- Understand **Source** and **Destination**
- Deploy an application from Git
- Observe **Sync Status**
- Observe **Health Status**
- Verify the deployed application
- Delete and recreate an Application

---

## Repository Structure

```
episode-04-deploy-first-application/
│
├── application.yaml                 # Argo CD Application
├── README.md                        # Episode documentation (this file)
│
└── techops-demo/
    ├── namespace.yaml                # Namespace
    ├── configmap.yaml                # HTML page
    ├── deployment.yaml               # NGINX Deployment
    ├── service.yaml                  # NodePort Service
    └── README.md                     # Application documentation
```

---

## Prerequisites

- A running Kubernetes cluster
- Argo CD installed on the cluster
- `kubectl` configured to talk to the cluster
- `git`

---

## Deploy Steps

1. Clone this repository:

   ```bash
   git clone https://github.com/Sagar-CloudNative/gitops-argocd-tutorial-series.git
   cd gitops-argocd-tutorial-series/episode-04-deploy-first-application
   ```

2. `application.yaml` already points at this repo's `main` branch and the
   `episode-04-deploy-first-application/techops-demo` path — no edits needed.
3. Apply the Argo CD Application:

   ```bash
   kubectl apply -f application.yaml
   ```

4. Watch Argo CD pick it up:

   ```bash
   kubectl get applications -n argocd
   ```

5. Sync it manually (Episode 4 uses manual sync — automated sync arrives in Episode 5):

   ```bash
   argocd app sync techops-demo
   ```

   Or click **Sync** in the Argo CD UI.

---

## Verification Commands

```bash
kubectl get applications -n argocd
kubectl get pods -n demo
kubectl get svc -n demo
```

## View in Browser

```bash
kubectl get svc -n demo
```

Then open:

```
http://<NODE-IP>:30080
```

You should see the **TechOps Tutorials** Argo CD demo page.

---

## Cleanup

```bash
kubectl delete -f application.yaml
```

Argo CD will prune the `demo` namespace resources on delete (finalizer is set
in `application.yaml`).

---

## What's Next

| Episode | Topic |
|---|---|
| Episode 4 | Manual Deployment (this episode) |
| Episode 5 | Auto Sync |
| Episode 6 | Self Healing |
| Episode 7 | Rollback |

Future episodes will modify `techops-demo/configmap.yaml` to demonstrate the
full GitOps workflow — commit, push, and watch Argo CD reconcile the cluster
automatically.
