FROM debian:bookworm-slim

ARG TARGETARCH
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git jq bash coreutils \
    && rm -rf /var/lib/apt/lists/*

# yq (mikefarah) pinned
ARG YQ_VERSION=v4.44.3
RUN curl -fsSL -o /usr/local/bin/yq \
    "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${TARGETARCH}" \
    && chmod +x /usr/local/bin/yq

# Trivy pinned
ARG TRIVY_VERSION=0.56.2
RUN curl -fsSL "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-${TARGETARCH}.tar.gz" \
  | tar -xz -C /usr/local/bin trivy

# Syft pinned
ARG SYFT_VERSION=1.16.0
RUN curl -fsSL "https://github.com/anchore/syft/releases/download/v${SYFT_VERSION}/syft_${SYFT_VERSION}_linux_${TARGETARCH}.tar.gz" \
  | tar -xz -C /usr/local/bin syft

# Semgrep pinned (pipx in a global location to avoid PEP 668 + /root perms)
ARG SEMGREP_VERSION=1.103.0
ENV PIPX_HOME=/opt/pipx
ENV PIPX_BIN_DIR=/usr/local/bin
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip pipx \
    && pipx install "semgrep==${SEMGREP_VERSION}" \
    && chmod -R a+rX /opt/pipx \
    && chmod a+rx /usr/local/bin/semgrep \
    && rm -rf /var/lib/apt/lists/*


# Sonar Scanner pinned
ARG SONAR_SCANNER_VERSION=6.2.1.4610
ARG TARGETARCH
RUN set -eux; \
    if [ "$TARGETARCH" = "arm64" ]; then \
        SCANNER_ARCH="aarch64"; \
    else \
        SCANNER_ARCH="x64"; \
    fi; \
    curl -fsSL -o /tmp/sonar-scanner.zip \
      "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-${SCANNER_ARCH}.zip"; \
    apt-get update && apt-get install -y --no-install-recommends unzip; \
    unzip /tmp/sonar-scanner.zip -d /opt; \
    ln -s /opt/sonar-scanner-*/bin/sonar-scanner /usr/local/bin/sonar-scanner; \
    rm -f /tmp/sonar-scanner.zip; \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 10001 ci && mkdir -p /workspace && chown -R ci:ci /workspace

USER ci
WORKDIR /workspace

CMD ["bash", "-lc", "echo 'CI Tools Image: $(syft version) | $(trivy --version | head -n 1) | $(yq --version) | $(semgrep --version) | $(sonar-scanner --version | head -n 1)'"]
