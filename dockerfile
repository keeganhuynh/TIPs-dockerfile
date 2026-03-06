FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

SHELL ["/bin/bash", "-lc"]

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates unzip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN git clone https://github.com/keeganhuynh/TIPs-containerized.git \
    && mv /TIPs-containerized /TIPs

WORKDIR /TIPs

RUN python -m pip install --upgrade pip \
 && pip install "mamba-ssm[causal-conv1d]" --no-build-isolation

RUN pip install -e .

RUN pip install jupyterlab

RUN chmod +x /TIPs/initialize.sh

EXPOSE 8888

CMD ["/bin/bash", "-c", "/TIPs/initialize.sh && jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.allow_origin='*' \
  --ServerApp.allow_remote_access=True \
  --ServerApp.tornado_settings='{\"headers\": {\"Content-Security-Policy\": \"frame-ancestors *\"}}'"]