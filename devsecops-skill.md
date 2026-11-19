---
name: devsecops-security-enforcer
description: Enforce DevSecOps best practices, automated security gates, and toolchain configurations across code generation, CI/CD pipelines, Infrastructure as Code (IaC), containers, and cloud deployments. Use when writing application code, configuring CI/CD workflows, provisioning infrastructure, auditing dependencies, or troubleshooting security vulnerabilities.
---

# DevSecOps Security Enforcer

Apply security-by-default principles across every stage of software generation and delivery. Never generate insecure defaults, hardcoded secrets, unpinned dependencies, or overly permissive infrastructure configurations.

## Core Execution Directives

1. **Shift Left by Default:** Write secure code and infrastructure definitions immediately rather than deferring security to manual post-deployment reviews.
2. **Zero Hardcoded Secrets:** Never output API keys, passwords, tokens, or private certificates in source code, configuration files, or CI/CD scripts. Always use environment variables or secret manager references (e.g., `${{ secrets.API_KEY }}`, AWS Secrets Manager, HashiCorp Vault).
3. **Least Privilege Everywhere:** Scope all IAM roles, Kubernetes RBAC policies, database users, and container execution contexts to the minimum permissions required.
4. **Automate Security Gates:** Whenever generating or modifying CI/CD pipelines (GitHub Actions, GitLab CI, Jenkins, Azure DevOps), include automated security scanning jobs that block merges or deployments on critical/high severity findings.

---

## SDLC Phase Guardrails & Tool Selection

Select and configure the appropriate security controls based on the task context:

### 1. Code & Application Logic (AST)
* **Trigger:** Writing or refactoring application source code, authentication flows, database queries, or API endpoints.
* **Directives:**
  * Use parameterized queries/ORMs to prevent SQL injection; sanitize and encode outputs to prevent XSS.
  * Enforce strict input validation (schema validation via Zod, Pydantic, Joi, etc.) on all external inputs.
  * Configure **SAST** rules in CI to catch regressions automatically.
* **Recommended Tools:**
  * *Open-Source:* `Semgrep`, `Bandit` (Python), `ESLint Security Plugins` (JS/TS), `Gosec` (Go), `CodeQL`.
  * *Commercial:* `SonarQube`, `Snyk Code`, `Checkmarx`.

### 2. Dependencies & Supply Chain (SCA & SBOM)
* **Trigger:** Adding packages, editing `package.json`, `requirements.txt`, `go.mod`, `pom.xml`, or building release artifacts.
* **Directives:**
  * Pin exact dependency versions and commit lockfiles (`package-lock.json`, `poetry.lock`, `go.sum`).
  * Recommend generating a Software Bill of Materials (SBOM) in CycloneDX or SPDX format during builds.
  * Configure **SCA** checks to fail builds on known exploitable CVEs.
* **Recommended Tools:**
  * *Open-Source:* `OWASP Dependency-Check`, `OSV-Scanner`, `Syft` (SBOM generation), `Cosign` (artifact signing).
  * *Commercial:* `Snyk Open Source`, `Dependabot`, `Mend.io`, `JFrog Xray`.

### 3. Secrets Detection & Management
* **Trigger:** Creating `.env.example` files, configuring runtime environments, or auditing repositories.
* **Directives:**
  * Ensure `.env`, `*.pem`, `*.key`, and credential files are explicitly listed in `.gitignore` and `.dockerignore`.
  * Inject pre-commit hooks or CI secret scanners to prevent accidental commits.
* **Recommended Tools:**
  * *Open-Source:* `Gitleaks`, `TruffleHog`, `detect-secrets`.
  * *Commercial:* `GitGuardian`, `GitHub Secret Protection`, `HashiCorp Vault`.

### 4. Infrastructure as Code (IaC)
* **Trigger:** Writing Terraform, OpenTofu, CloudFormation, Bicep, Ansible, or Helm charts.
* **Directives:**
  * Enable encryption at rest and in transit (TLS 1.2+) for all storage buckets, databases, and message queues.
  * Block public ingress (`0.0.0.0/0`) on sensitive ports (SSH, RDP, databases) and disable public S3/blob access by default.
  * Include **IaC static scanning** in pull request checks.
* **Recommended Tools:**
  * *Open-Source:* `Checkov`, `Trivy` (config scan), `KICS`, `Terrascan`.
  * *Commercial:* `Prisma Cloud`, `Wiz`, `Snyk IaC`.

### 5. Containers & Kubernetes
* **Trigger:** Writing `Dockerfile`s, `docker-compose.yml`, or Kubernetes manifests (`Deployment`, `Pod`, `Ingress`, `NetworkPolicy`).
* **Directives:**
  * Use minimal, pinned base images (`distroless`, `alpine`, or specific digest SHA256 tags); avoid `:latest`.
  * Run containers as a non-root user (`USER 10001`), drop unnecessary Linux capabilities, and set `readOnlyRootFilesystem: true` where possible.
  * Scan built container images prior to pushing to registries.
* **Recommended Tools:**
  * *Open-Source:* `Trivy`, `Grype`, `Hadolint` (Dockerfile linting), `Kubescape`, `Falco` (runtime).
  * *Commercial:* `Aqua Security`, `Sysdig Secure`, `Wiz`.

### 6. Dynamic Testing & API Security (DAST & ASPM)
* **Trigger:** Configuring staging pipelines, exposing REST/GraphQL APIs, or consolidating security findings.
* **Directives:**
  * Enforce authentication, rate limiting, and strict CORS policies on all API endpoints.
  * Schedule automated **DAST** scans against staging/ephemeral preview environments before production promotion.
* **Recommended Tools:**
  * *Open-Source:* `OWASP ZAP`, `Nuclei`, `DefectDojo` (vulnerability aggregation/ASPM).
  * *Commercial:* `Burp Suite Enterprise`, `StackHawk`, `ArmorCode`, `Cycode`.

---

## AI Coding Session Checklist

Before finalizing any code, infrastructure, or pipeline output, verify:
- [ ] **No Secrets:** Are all credentials externalized via secret stores or environment variables?
- [ ] **Input & Auth:** Are all inputs validated and endpoints protected by authentication and authorization checks?
- [ ] **Pinned & Minimal:** Are dependencies, base images, and CI actions pinned to specific versions or hashes?
- [ ] **Least Privilege:** Are IAM roles, container users, and network rules restricted to minimum required access?
- [ ] **Automated Gates:** Does the CI/CD pipeline include SAST, SCA, Secret, and IaC/Container scans?
