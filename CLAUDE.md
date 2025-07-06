# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

bpfshoot is a containerized BPF (Berkeley Packet Filter) troubleshooting toolkit that provides pre-built BPF tools for system observability, performance analysis, and network troubleshooting. It supports two variants:

1. **libbpf CO-RE version** (Dockerfile): Built on Debian Bookworm, uses libbpf CO-RE technology for kernel portability
2. **BCC version** (Dockerfile.bcc): Built on Debian Trixie, uses traditional BCC tools for older kernel compatibility

## Architecture

The project consists of:
- **Dockerfile**: libbpf CO-RE version - builds BCC v0.35.0 libbpf-tools from source on Debian Bookworm
- **Dockerfile.bcc**: BCC version - installs pre-packaged BCC tools on Debian Trixie
- **Makefile**: Build automation supporting multi-architecture Docker builds (x86_64, ARM64)
- **GitHub Actions**: Automated CI/CD pipeline for multi-arch builds and Docker Hub publishing

Both containers include:
- Network diagnostic tools (iproute2, net-tools)
- System utilities (procps, vim, git, jq)
- Complete BPF toolchain (libbpf CO-RE version includes clang, llvm, libelf-dev)

## Key Technical Details

**libbpf CO-RE version** (`johnlin/bpfshoot:latest`):
- Uses libbpf CO-RE technology - no kernel headers or debug filesystem mounts required
- Requires Linux kernel 5.15+ with BPF support
- Tools located in `/bcc/libbpf-tools/` and installed system-wide

**BCC version** (`johnlin/bpfshoot:latest-bcc`):
- Uses traditional BCC tools from Debian packages
- Requires Linux kernel 4.1+ with BPF support
- Needs kernel headers mounted: `-v /lib/modules:/lib/modules:ro -v /sys:/sys:ro -v /usr/src:/usr/src:ro`
- Tools available system-wide via bpfcc-tools package

Both versions:
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

# Create and push a release tag (VERSION defaults to 0.0.1, can be overridden)
make release VERSION=0.0.2

# Just build with custom version
make build-all VERSION=0.0.3
```

### Local Development and Testing
```bash
# Test locally built images
docker run -it --rm --privileged --pid=host --name bpfshoot-test \
  -v /sys/kernel/debug:/sys/kernel/debug \
  johnlin/bpfshoot:0.0.1

# Test BCC version
docker run -it --rm --privileged --pid=host --name bpfshoot-test \
  -v /lib/modules:/lib/modules:ro \
  -v /sys:/sys:ro \
  -v /usr/src:/usr/src:ro \
  johnlin/bpfshoot:0.0.1

# For macOS development - start Lima VM and connect
limactl start --name linux-vm lima/linux-vm.yaml
limactl shell linux-vm
```

### Running the Container
```bash
# libbpf CO-RE version (modern kernels 5.15+)
docker run -it --rm --privileged --pid=host --name bpfshoot \
  -v /sys/kernel/debug:/sys/kernel/debug \
  johnlin/bpfshoot:latest

# BCC version (older kernels 4.1+)
docker run -it --rm --privileged --pid=host --name bpfshoot \
  -v /lib/modules:/lib/modules:ro \
  -v /sys:/sys:ro \
  -v /usr/src:/usr/src:ro \
  johnlin/bpfshoot:latest-bcc
```

### Inside the Container
```bash
# libbpf CO-RE version - tools available system-wide or in /bcc/libbpf-tools/
opensnoop      # Trace file opens
execsnoop      # Trace process execution  
tcpconnect     # Trace TCP connections

# BCC version - tools available system-wide
opensnoop-bpfcc    # Trace file opens
execsnoop-bpfcc    # Trace process execution
tcpconnect-bpfcc   # Trace TCP connections
```

## GitHub Actions CI/CD

The repository includes automated workflows (`.github/workflows/docker-build.yml`) that:
- Build both Dockerfile variants (libbpf CO-RE and BCC) in parallel using matrix strategy
- Build multi-architecture Docker images (linux/amd64, linux/arm64)
- Automatically tag images with appropriate suffixes (`latest` and `latest-bcc`)
- Push to Docker Hub on main branch commits and tags
- Generate build attestations for security
- Use GitHub Actions cache for faster builds

**Triggers:**
- Push to main branch when Dockerfile or Dockerfile.bcc changes
- Git tags starting with 'v' (e.g., v0.0.2)
- Pull requests for testing (build only, no push)

**Image tagging strategy:**
- `johnlin/bpfshoot:latest` - libbpf CO-RE version from Dockerfile
- `johnlin/bpfshoot:latest-bcc` - BCC version from Dockerfile.bcc
- Additional tags for branches, PRs, semver, and SHA

**Required secrets in GitHub repository:**
- `DOCKER_USERNAME`: johnlin
- `DOCKER_PASSWORD`: Docker Hub access token

## Development Notes

- All BPF programs require privileged container execution (`--privileged` flag)
- Use `--pid=host` for system-wide process monitoring (required for most BPF tools)
- The environment is designed for defensive security analysis and system monitoring
- libbpf CO-RE version: tools pre-compiled and installed system-wide (also available in `/bcc/libbpf-tools/`)
- BCC version: tools available system-wide with `-bpfcc` suffix
- Container hostnames: `bpfshoot` (CO-RE) and `bcc-tools` (BCC)
- Current version is defined in Makefile as VERSION=0.0.1 (overridable with make command)
- Workflow builds both variants automatically on Dockerfile changes

**Key Build Components:**
- `Dockerfile`: libbpf CO-RE version - builds BCC v0.35.0 libbpf-tools from source on Debian Bookworm
- `Dockerfile.bcc`: BCC version - installs pre-packaged bpfcc-tools on Debian Trixie
- `Makefile`: Handles multi-arch builds, versioning, and release process
- `.github/workflows/docker-build.yml`: Automated CI/CD for both variants

## Local Development Environment

For local development and testing, the project includes a Lima VM configuration (`linux-vm.yaml`) that provides:
- Docker support with BPF development tools
- Pre-installed BCC tools and dependencies
- Configured kernel headers and build environment

### Setting up Lima VM
```bash
# For ARM64 (Apple Silicon)
limactl start --arch aarch64 --name linux-vm linux-vm.yaml

# For x86_64 (Intel/AMD)
limactl start --arch x86_64 --name linux-vm-x86 linux-vm.yaml
```

The Lima VM includes all necessary BPF development tools and can be used for testing container functionality on macOS.