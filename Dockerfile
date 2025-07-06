FROM debian:bookworm

RUN echo deb http://cloudfront.debian.net/debian sid main >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    ca-certificates \
    pbuilder \
    aptitude \
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

RUN git clone --recurse-submodules --branch v0.35.0 --depth 1 https://github.com/iovisor/bcc.git \
    && cd bcc/libbpf-tools \
    && make \
    && make install 

# Setting User and Home
USER root
WORKDIR /root
ENV HOSTNAME=bptshoot

# Running bash
CMD ["bash"]
