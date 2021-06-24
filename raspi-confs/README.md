# Raspberry Pi Testbed

Use Raspberry Pi as the gateway

## Setup

Raspberry Pi is connected with two Ethernet cables that are both linked to the same PC.

1. Configure Raspberry Pi

    ```bash
    # Create a seperate network namespace
    sudo ip netns add gatekeeper

    # Move two ethernet interfaces into it
    sudo ip link set eth0 netns gatekeeper
    sudo ip link set eth1 netns gatekeeper

    # Enter the created network namespace
    sudo nsenter --net=/var/run/netns/gatekeeper bash

    # Create a bridge and configure it
    sudo ip link add br0 type bridge
    sudo ip link set eth0 master br0
    sudo ip link set eth1 master br0
    sudo ip addr add 172.50.1.1/24 brd + dev br0

    # Enable all of them
    sudo ip link set br0 up
    sudo ip link set eth0 up
    sudo ip link set eth1 up
    ```

2. Configure the connected PC

    ```bash

    ```

## Performance Baseline

We shift the IP address of the lwip stack by 5, so that the kernel will not process any TCP packets from the lwip stack. Otherwise, the kernel will reset the TCP connection during the handshake.

```bash
alice# sudo PRECONFIGURED_RAWIF=enp5s0 LD_PRELOAD=/code/liblwip_preload.so iperf3 -s -p 8080 -4 -d
  bob# sudo PRECONFIGURED_RAWIF=enx000ec6a11196 LD_PRELOAD=/code/liblwip_preload.so iperf3 -c 172.50.1.7 -p 8080 -i 60 -4 -n 104857600 -b 0 -d
```
