# bpfshoot

```
     _            __      _                 _
    | |          / _|    | |               | |
    | |__  _ __ | |_ ___| |__   ___   ___ | |_
    | '_ \| '_ \|  _/ __| '_ \ / _ \ / _ \| __|
    | |_) | |_) | | \__ \ | | | (_) | (_) | |_
    |_.__/| .__/|_| |___/_| |_|\___/ \___/ \__|
          | |
          |_|
```

**A containerized BPF troubleshooting toolkit inspired by [nicolaka/netshoot](https://github.com/nicolaka/netshoot)**

## Purpose

`bpfshoot` is a Docker container packed with BPF (Berkeley Packet Filter) tools for system observability, performance analysis, and network troubleshooting. It provides a complete BPF development and debugging environment using libbpf CO-RE (Compile Once - Run Everywhere) technology that can be easily deployed across different platforms.

## Quick Start

### Docker

```bash
# For modern Linux kernels (5.15+) - libbpf CO-RE version
docker run -it --rm --privileged --pid=host --name bpfshoot johnlin/bpfshoot:latest

# For older Linux kernels (4.1+) - BCC version
docker run -it --rm --privileged --pid=host --name bpfshoot \
  -v /lib/modules:/lib/modules:ro \
  -v /sys:/sys:ro \
  -v /usr/src:/usr/src:ro \
  johnlin/bpfshoot:latest-bcc
```

### Kubernetes

#### libbpf CO-RE version (for modern kernels 5.15+)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: bpfshoot
spec:
  hostNetwork: true
  hostPID: true
  containers:
  - name: bpfshoot
    image: johnlin/bpfshoot:latest
    stdin: true
    tty: true
    securityContext:
      privileged: true
```

#### BCC version (for older kernels 4.1+)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: bpfshoot-bcc
spec:
  hostNetwork: true
  hostPID: true
  containers:
  - name: bpfshoot
    image: johnlin/bpfshoot:latest-bcc
    stdin: true
    tty: true
    securityContext:
      privileged: true
    volumeMounts:
    - name: lib-modules
      mountPath: /lib/modules
      readOnly: true
    - name: sys
      mountPath: /sys
      readOnly: true
    - name: usr-src
      mountPath: /usr/src
      readOnly: true
  volumes:
  - name: lib-modules
    hostPath:
      path: /lib/modules
  - name: sys
    hostPath:
      path: /sys
  - name: usr-src
    hostPath:
      path: /usr/src
```

## Included BPF Tools

This container includes the complete set of BPF tools from the BCC project. For detailed tool descriptions and usage examples, please refer to the [BCC Tools documentation](https://github.com/iovisor/bcc?tab=readme-ov-file#tools).

All tools are pre-compiled and installed in the system PATH, ready to use directly from the command line.

## Building from Source

### Prerequisites
- Docker with BuildKit support
- Multi-architecture build support (optional)

### Build Commands
```bash
# Build for current architecture
make build-x86    # or make build-arm64

# Build for all architectures
make build-all

# Build and push to registry
make all
```

## Release Process

```bash
# Create and push release tag with version
make release VERSION=0.0.2

# Or manually:
# 1. git tag -a v0.0.2 -m "Release v0.0.2"
# 2. git push origin v0.0.2
```

GitHub Actions will automatically build and push both variants (`latest` and `latest-bcc`) to Docker Hub when tags are pushed.

## Requirements

- **Linux Kernel**:
  - 5.15+ with BPF support (for libbpf CO-RE version)
  - 4.1+ with BPF support (for BCC version with `-bcc` tag)
- **Privileged Access**: Required for BPF program loading

## Acknowledgments

- Inspired by [nicolaka/netshoot](https://github.com/nicolaka/netshoot)
- Built on [BCC (BPF Compiler Collection)](https://github.com/iovisor/bcc)
- Thanks to the Linux kernel BPF community
