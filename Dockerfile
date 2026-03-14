# ── Stage 1: Build ──────────────────────────────────────────────
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04 AS builder

ENV PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

# venv inherits base-image PyTorch / CUDA packages
RUN python -m venv --system-site-packages /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN git clone --depth 1 https://github.com/huylenq/dentalml.git /dentalml

WORKDIR /dentalml/vendor/tips

RUN pip install --upgrade pip \
    && pip install "mamba-ssm[causal-conv1d]" --no-build-isolation \
    && pip install . \
    && find /opt/venv -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null; true

# ── Stage 2: Runtime ───────────────────────────────────────────
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

SHELL ["/bin/bash", "-lc"]

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /dentalml/vendor/tips /tips

WORKDIR /tips
