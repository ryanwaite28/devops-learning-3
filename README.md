# Kubernetes Platform Engineering DevSecOps Lab

## Overview

This repository demonstrates **enterprise-grade platform engineering and DevSecOps practices** using Kubernetes as the core control plane and Jenkins Cloud for elastic CI/CD execution. The goal is to showcase how a modern organization designs, secures, operates, and observes a Kubernetes-based internal developer platform (IDP).

The application itself is intentionally simple. **The platform is the product.**

This lab is designed to be:

* Fully reproducible on a local machine
* Built entirely with open-source tooling
* Structured like a real enterprise platform
* Resume- and interview-ready for senior/staff DevOps and platform roles

---

## Key Capabilities Demonstrated

* Kubernetes as a platform (not just workload orchestration)
* Jenkins Cloud with ephemeral, autoscaled agents on Kubernetes
* Shift-left DevSecOps with enforced security gates
* Secrets management decoupled from CI/CD and runtime
* Policy-driven governance and admission control
* End-to-end observability (metrics, logs, alerts)
* Reproducible platform bootstrapping and documentation

---

## Architecture Diagram

```
+------------------+        +-------------------+
|   Developer      |        |  Platform Admin   |
| (Local Machine)  |        |                   |
+--------+---------+        +---------+---------+
         |                              |
         | Git Push                     | Platform Ops
         v                              v
+------------------------ Docker Compose -------------------------+
|                                                                  |
|  +-------------+     +----------------+     +---------------+  |
|  | GitLab CE   | --> | Jenkins        | --> | Infisical     |  |
|  | (SCM)       |     | Controller     |     | (Secrets)    |  |
|  +-------------+     +--------+-------+     +---------------+  |
|                                   |                              |
+-----------------------------------|------------------------------+
                                    v
                          +--------------------+
                          | Kubernetes Cluster |
                          | (kind / k3d)       |
                          +--------------------+
                                    |
        -------------------------------------------------------------------
        |               |                 |                |               |
        v               v                 v                v               v
+---------------+ +---------------+ +---------------+ +---------------+ +---------------+
| CI Namespace  | | App Namespace | | Security NS   | | Observability | | Ingress       |
|               | |               | |               | | Namespace     | | Controller    |
| Jenkins Agent | | App Pods      | | Trivy         | | Prometheus    | | NGINX         |
| Pods (Ephem.) | | Postgres      | | Gatekeeper    | | Grafana       | |               |
|               | | Redis         | | Kyverno       | | Loki          | |               |
+---------------+ +---------------+ +---------------+ +---------------+ +---------------+
```

---

## Core Technology Stack

### Platform & Infrastructure

* Kubernetes: kind or k3d
* Container Runtime: Docker
* Orchestration: Docker Compose

### CI/CD & SCM

* GitLab CE (self-hosted)
* Jenkins Controller
* Jenkins Kubernetes Plugin
* Jenkins Shared Libraries

### Security (DevSecOps)

* Secrets Management: Infisical
* SAST: Semgrep
* Dependency Scanning: OWASP Dependency-Check
* Image Scanning: Trivy
* SBOM: Syft
* Policy Enforcement: OPA Gatekeeper
* Admission Policies: Kyverno

### Observability

* Metrics: Prometheus
* Visualization: Grafana
* Logs: Loki + Promtail
* Alerts: Alertmanager

---

## CI/CD Pipeline Flow

1. Code pushed to GitLab
2. Jenkins pipeline triggered
3. Jenkins provisions ephemeral Kubernetes agent pod
4. Pipeline stages executed:

   * SAST (Semgrep)
   * Dependency scan
   * Container build
   * Image scan
   * SBOM generation
   * Image push
   * Kubernetes deploy
   * Post-deploy validation
5. Agent pod destroyed

Security failures fail the pipeline by design.

---

## Security Model

* No secrets stored in Git or Jenkins
* All secrets pulled dynamically from Infisical
* Admission controllers enforce:

  * Resource limits
  * Approved registries
  * No mutable image tags
* Network policies restrict lateral movement

---

## Observability Model

* Jenkins metrics scraped by Prometheus
* Application metrics exposed via /metrics
* Centralized logging via Loki
* Grafana dashboards for:

  * CI performance
  * Cluster health
  * Application SLIs

---

## Project Rubric / Completion Checklist

### Platform Foundation

* [ ] Docker Compose boots all platform services
* [ ] Kubernetes cluster created reproducibly
* [ ] Namespaces logically separated
* [ ] Ingress configured and functional

### Jenkins Cloud

* [ ] Jenkins controller deployed
* [ ] Kubernetes plugin configured
* [ ] Ephemeral agent pods provision per job
* [ ] Resource limits enforced on agents
* [ ] Pipeline isolation demonstrated

### CI/CD

* [ ] Jenkinsfile stored as code
* [ ] Multi-stage pipeline implemented
* [ ] Artifact registry integrated
* [ ] Pipeline failures block promotion

### DevSecOps

* [ ] SAST integrated
* [ ] Dependency scanning enforced
* [ ] Image scanning blocks critical vulns
* [ ] SBOM generated per build
* [ ] Secrets never stored in plaintext

### Kubernetes Security

* [ ] OPA Gatekeeper policies enforced
* [ ] Kyverno policies active
* [ ] Network policies implemented
* [ ] Pod Security Standards applied

### Observability

* [ ] Prometheus scraping configured
* [ ] Grafana dashboards created
* [ ] Centralized logging enabled
* [ ] Alert rules defined

### Documentation

* [ ] Architecture documented
* [ ] Threat model included
* [ ] Design decisions explained
* [ ] Production-readiness discussion added

---

## What This Project Demonstrates to Employers

* Ability to design internal developer platforms
* Mastery of Kubernetes-based CI/CD
* Practical DevSecOps implementation
* Security-first platform thinking
* Enterprise-level documentation and structure

---

## Future Enhancements (Optional)

* GitOps with ArgoCD
* Canary deployments
* Cosign image signing
* SLOs and error budgets
* Multi-cluster federation

---

## Final Note

This lab intentionally mirrors real-world platform engineering challenges. Completing every checklist item means this project reflects **senior-to-staff level DevSecOps capability**.
