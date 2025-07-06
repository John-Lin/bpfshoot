# Lima VM Setup for macOS

## Quick Start

### Install Lima
```bash
brew install lima

# For x86_64 architecture on Apple Silicon, install additional guest agents
brew install lima-additional-guestagents
```

### Start the VM
```bash
limactl start --name linux-vm lima/linux-vm.yaml

# For creating a vm with x86_64
limactl start --arch x86_64 --name linux-vm-x86 lima/linux-vm.yaml
```

### Connect to VM
```bash
limactl shell linux-vm
```

### Run bpfshoot inside the VM
```bash
docker run -it --rm --privileged --pid=host --name bpfshoot \
  -v /sys/kernel/debug:/sys/kernel/debug \
  johnlin/bpfshoot:latest
```

## Documentation

For detailed Lima usage, visit the [official Lima documentation](https://lima-vm.io/docs/).
