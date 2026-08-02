# TechOps Demo Application

## Purpose

This application is used throughout the **TechOps Tutorials** GitOps series
to demonstrate Argo CD concepts on a small, branded NGINX app instead of the
generic Guestbook example.

## Manifests

| File | Resource | Purpose |
|---|---|---|
| `namespace.yaml` | Namespace | Creates the `demo` namespace |
| `configmap.yaml` | ConfigMap | Holds the branded `index.html` page |
| `deployment.yaml` | Deployment | Runs `nginx:stable-alpine`, mounts the ConfigMap over the default page |
| `service.yaml` | Service (NodePort) | Exposes the app on port `30080` |

## How It's Used Across the Series

| Episode | Focus |
|---|---|
| **Episode 4** | Manual Deployment |
| **Episode 5** | Auto Sync |
| **Episode 6** | Self Healing |
| **Episode 7** | Rollback |

Future episodes will modify `configmap.yaml` (for example, bumping the
`Version` shown on the page) to demonstrate the full GitOps loop:

```
Edit configmap.yaml → Commit → Push → Argo CD detects OutOfSync → Sync → Refresh browser
```

## Quick Local Test (without Argo CD)

```bash
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

kubectl get pods -n demo
kubectl get svc -n demo
```

Then open `http://<NODE-IP>:30080` in your browser.
