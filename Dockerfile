FROM debian:bookworm

# BCC version tag
ARG BCC_VERSION=v0.35.0
LABEL bcc.version=${BCC_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    ca-certificates \
    git \
    jq \
    procps \
    net-tools \
    iproute2 \
    vim \
    python3-pip \
    apt-transport-https \
    clang \
    llvm \
    libelf-dev \
    libpcap-dev \
    libbfd-dev \
    binutils-dev \
    build-essential \
    make \
    linux-perf \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --recurse-submodules --branch ${BCC_VERSION} --depth 1 https://github.com/iovisor/bcc.git \
    && cd bcc/libbpf-tools \
    && make \
    && make install 

# Setting User and Home
USER root
WORKDIR /root
ENV HOSTNAME=bpfshoot

# Running bash
CMD ["bash"]
