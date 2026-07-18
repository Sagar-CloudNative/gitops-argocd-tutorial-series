# Episode 1: Introduction to GitOps – Concepts & Why It Matters

📺 [Watch this episode](#) <!-- add YouTube video link once published -->

## What You'll Learn
- Problems with traditional push-based Kubernetes deployments
- What GitOps is and why it matters
- The 4 core principles of GitOps
- Push-based CI/CD vs Pull-based GitOps
- Understanding Configuration Drift
- Why Git becomes the Single Source of Truth
- The complete GitOps workflow
- Popular GitOps tools: Argo CD, Flux CD, Jenkins X
- Why this series uses Argo CD
- High-level Argo CD architecture

## Key Concepts

### The 4 Core Principles of GitOps
1. **Declarative Configuration** — describe the desired end state, not step-by-step commands
2. **Version Controlled** — all configuration lives in Git with full commit history
3. **Automatically Applied** — a GitOps tool applies changes from Git automatically
4. **Continuously Synced** — the tool continuously checks and corrects drift between Git and the cluster

### Push vs Pull

| | Push-Based CI/CD | Pull-Based GitOps |
|---|---|---|
| Who deploys | CI/CD pipeline | Argo CD (inside the cluster) |
| Cluster credentials | Stored in CI/CD system | Stay inside the cluster |
| Configuration drift | Not automatically detected | Automatically detected & corrected |
| Rollback | Re-run pipeline with older version | Revert Git commit |

## Note
This is a conceptual episode — no hands-on YAML/configs yet. Hands-on setup begins in Episode 2.

## Next Episode
Episode 2 will cover structuring a Git repository for GitOps — organizing folders and environments.
