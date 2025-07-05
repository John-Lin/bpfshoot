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
docker run -it --rm --privileged --name bpfshoot johnlin/bpfshoot:latest
```

### Kubernetes

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

## Included BPF Tools

### Process & System Monitoring
- **execsnoop** - Trace process execution
- **opensnoop** - Trace file opens
- **statsnoop** - Trace file stats
- **syncsnoop** - Trace sync() calls
- **killsnoop** - Trace kill() signals

### Network Analysis
- **tcpconnect** - Trace TCP connections
- **tcpaccept** - Trace TCP accepts
- **tcpretrans** - Trace TCP retransmissions
- **tcplife** - Trace TCP session lifespans
- **sockmap** - Trace socket map operations

### Storage & I/O
- **biosnoop** - Trace block I/O
- **biolatency** - Block I/O latency histograms
- **biotop** - Top for block I/O
- **filetop** - Top for file reads/writes
- **vfsstat** - VFS statistics

### Memory & CPU
- **memleak** - Trace memory leaks
- **cpudist** - CPU usage distribution
- **profile** - CPU profiling
- **offcputime** - Off-CPU time profiling

### Kernel Tracing
- **trace** - Trace kernel functions
- **argdist** - Argument distribution
- **funccount** - Count kernel function calls
- **stackcount** - Count stack traces


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

## Requirements

- **Linux Kernel**: 5.15+ with BPF support
- **Privileged Access**: Required for BPF program loading

## Acknowledgments

- Inspired by [nicolaka/netshoot](https://github.com/nicolaka/netshoot)
- Built on [BCC (BPF Compiler Collection)](https://github.com/iovisor/bcc)
- Thanks to the Linux kernel BPF community