FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

SHELL ["/bin/bash", "-lc"]

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates unzip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN git clone https://github.com/keeganhuynh/TIPs-containerized.git

WORKDIR /workspace/TIPs-containerized/TIPs

RUN python -m pip install --upgrade pip \
 && pip install "mamba-ssm[causal-conv1d]" --no-build-isolation

RUN pip install -e .

RUN pip install gdown \
    && gdown "1UuFgZ-kwRryPC-vK7w64xX0VO4iOAeGt" -O /tmp/nnResults.zip \
    && [ $(stat -c%s /tmp/nnResults.zip) -gt 100000 ] || (echo "ERROR: Download failed or file too small" && exit 1) \
    && unzip -q /tmp/nnResults.zip -d /tmp/nnResults_unzipped \
    && rm -f /tmp/nnResults.zip

RUN mkdir -p /workspace/TIPs-containerized/TIPs/nnResults \
    && cp -r /tmp/nnResults_unzipped/* /workspace/TIPs-containerized/TIPs/nnResults/ \
    && rm -rf /tmp/nnResults_unzipped

WORKDIR /workspace/TIPs-containerized/TIPs

CMD ["bash"]