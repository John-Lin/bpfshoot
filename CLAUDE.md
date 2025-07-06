# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

bpfshoot is a containerized BPF (Berkeley Packet Filter) troubleshooting toolkit built on Debian Bookworm. It provides pre-built BPF tools for system observability, performance analysis, and network troubleshooting using libbpf CO-RE (Compile Once - Run Everywhere) technology.

## Architecture

The project consists of:
- **Dockerfile**: Container build that installs BCC (BPF Compiler Collection) v0.35.0 and builds libbpf-tools
- **Makefile**: Build automation supporting multi-architecture Docker builds (x86_64, ARM64)
- **GitHub Actions**: Automated CI/CD pipeline for multi-arch builds and Docker Hub publishing

The container includes:
- BCC libbpf-tools (pre-built from source)
- Complete BPF development toolchain (clang, llvm, libelf-dev)
- Network diagnostic tools (iproute2, net-tools)
- System monitoring tools (linux-perf)

## Key Technical Details

- Uses libbpf CO-RE technology - no kernel headers or debug filesystem mounts required
- Requires Linux kernel 5.15+ with BPF support
- Must run with `--privileged` flag for BPF program loading
- Repository: `johnlin/bpfshoot` on Docker Hub

## Common Commands

### Building the Container
```bash
# Build for x86_64
make build-x86

# Build for ARM64  
make build-arm64

# Build multi-architecture (both x86_64 and ARM64)
make build-all

# Build and push to registry
make all
```

### Running the Container
```bash
# Run interactively with privileged access (required for BPF)
docker run -it --rm --privileged --name bpfshoot johnlin/bpfshoot:latest
```

### Inside the Container
```bash
# Navigate to BCC tools
cd /bcc/libbpf-tools

# Run BPF programs (examples)
./opensnoop    # Trace file opens
./execsnoop    # Trace process execution
./tcpconnect   # Trace TCP connections
```

## GitHub Actions CI/CD

The repository includes automated workflows that:
- Build multi-architecture Docker images (linux/amd64, linux/arm64)
- Automatically tag images based on branch, PR, semver, and SHA
- Push to Docker Hub on main branch commits and tags
- Generate build attestations for security

Required secrets in GitHub repository:
- `DOCKER_USERNAME`: johnlin
- `DOCKER_PASSWORD`: Docker Hub access token

## Development Notes

- All BPF programs require privileged container execution (`--privileged` flag)
- The environment is designed for defensive security analysis and system monitoring
- BCC tools are pre-compiled and ready to use in `/bcc/libbpf-tools/`
- Container hostname is set to `bptshoot` for identification
- Uses CO-RE technology for kernel portability across different Linux distributions