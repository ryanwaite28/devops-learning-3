# DevSecOps Overview, Tool Categories, and Toolchain Guide

## What is DevSecOps?

**DevSecOps** (Development, Security, and Operations) is the practice of automating and integrating security controls directly into every phase of the Software Development Lifecycle (SDLC). Rather than treating security as a final manual gate before release, DevSecOps embeds continuous testing, policy enforcement, and runtime monitoring into CI/CD pipelines so engineering teams can ship secure software rapidly.

### Core Principles
* **Shift Left:** Identify and remediate code vulnerabilities, leaked credentials, and infrastructure misconfigurations during design and development.
* **Automation Everywhere:** Trigger security scans automatically on pull requests, container builds, and deployments without slowing developer velocity.
* **Shared Responsibility:** Empower developers, security engineers, and operations teams with clear ownership and actionable findings.
* **Continuous Defense:** Monitor running workloads, cloud environments, and APIs in production to detect and block active threats.

---

## Core DevSecOps Tool Categories

### 1. Application Security Testing (AST)
Tools in this category inspect proprietary application code and running endpoints to uncover software flaws.

* **Static Application Security Testing (SAST):** Analyzes source code, bytecode, or binaries without executing the program to detect issues such as SQL injection, cross-site scripting (XSS), and insecure cryptographic implementations.
  * *Notable Tools:* SonarQube, Semgrep, Checkmarx, Fortify, CodeQL.
* **Dynamic Application Security Testing (DAST):** Tests running applications from the outside in by simulating malicious HTTP requests and attack patterns against staging or production endpoints.
  * *Notable Tools:* OWASP ZAP, Burp Suite, Invicti, StackHawk.
* **Interactive Application Security Testing (IAST):** Uses lightweight instrumentation agents inside a running application during functional testing to observe data flow and reduce false positives.
  * *Notable Tools:* Contrast Security, Seeker (Synopsys).

### 2. Software Supply Chain & Dependency Security
Modern applications assemble large volumes of open-source packages and third-party artifacts that require continuous auditing.

* **Software Composition Analysis (SCA):** Scans package manifests and lockfiles to identify known Common Vulnerabilities and Exposures (CVEs) and risky open-source licenses in third-party dependencies.
  * *Notable Tools:* Snyk, Mend.io, OWASP Dependency-Check, Dependabot.
* **Software Bill of Materials (SBOM) & Artifact Management:** Generates standardized component inventories (CycloneDX, SPDX) and stores verified, signed build artifacts.
  * *Notable Tools:* Syft, JFrog Artifactory, Sigstore (Cosign), Sonatype Nexus.
* **Secrets Management & Scanning:** Prevents hardcoded API keys, tokens, and passwords from entering version control while dynamically injecting secrets at runtime.
  * *Notable Tools:* HashiCorp Vault, TruffleHog, GitGuardian, Gitleaks, AWS Secrets Manager.

### 3. Infrastructure, Container & Cloud Security
These tools validate cloud configurations, container images, and orchestration clusters before and after deployment.

* **Infrastructure as Code (IaC) Scanning:** Audits declarative templates (Terraform, CloudFormation, Helm, Kubernetes manifests) for insecure defaults like public storage buckets or overly permissive IAM roles.
  * *Notable Tools:* Checkov, Terrascan, tfsec, KICS.
* **Container & Kubernetes Security:** Inspects container base images for OS and library vulnerabilities, enforces admission policies, and audits cluster posture.
  * *Notable Tools:* Trivy, Grype, Aqua Security, Kubescape, Kyverno.
* **Cloud-Native Application Protection Platforms (CNAPP):** Unifies Cloud Security Posture Management (CSPM) and Cloud Workload Protection (CWPP) to detect configuration drift, attack paths, and workload threats across cloud accounts.
  * *Notable Tools:* Wiz, Prisma Cloud, Orca Security, Lacework.

### 4. Runtime Defense, Monitoring & Posture Management
Once workloads are live, these categories protect against active exploitation and consolidate security telemetry.

* **Runtime Application Self-Protection (RASP) & Workload Detection:** Monitors live system calls, process execution, and network connections to detect and block anomalous behavior in real time.
  * *Notable Tools:* Falco, Tetragon, Imperva RASP, Sysdig Secure.
* **API Security:** Discovers shadow APIs, enforces schema validation, and detects broken object-level authorization (BOLA) and abuse in production traffic.
  * *Notable Tools:* Salt Security, Noname Security, 42Crunch.
* **Application Security Posture Management (ASPM):** Aggregates, deduplicates, and prioritizes findings across SAST, SCA, DAST, IaC, and cloud scanners into a unified risk view.
  * *Notable Tools:* DefectDojo, ArmorCode, Cycode, Apiiro.

---

## SDLC Phase Mapping

| SDLC Phase | Key Tool Categories | Primary Security Objective |
| :--- | :--- | :--- |
| **Plan & Code** | Threat Modeling, IDE Security Plugins, Pre-Commit Secrets Scanning | Catch insecure patterns and exposed credentials before code is pushed. |
| **Build** | SAST, SCA, IaC Scanning, SBOM Generation | Block builds containing critical code bugs, vulnerable libraries, or misconfigured templates. |
| **Test & Stage** | DAST, IAST, Container Image Scanning, Artifact Signing | Validate running applications against active exploit vectors and verify image integrity. |
| **Deploy & Operate** | CNAPP, Secrets Vaults, Runtime Detection (eBPF/RASP), API Security, ASPM | Enforce least privilege, block live anomalies, and prioritize remediation across environments. |
