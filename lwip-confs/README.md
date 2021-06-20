# Lwip

## Setup

1. Build `liblwip_preload.so` on host machine
2. Copy `liblwip_preload.so` to the root of `SecEthernetEval`
3. Use Docker's `host` network driver so that containers can share all network interfaces with the host machine

## Start

Run `udp_server` on `bob` at first. Then, run `udp_client` on `alice`.

```bash
  bob# PRECONFIGURED_TAPIF=tap0 LD_PRELOAD=/code/liblwip_preload.so ./udp_server

alice# IS_IP2=1 PRECONFIGURED_TAPIF=tap1 LD_PRELOAD=/code/liblwip_preload.so ./udp_client -b /code/data/can_frames.pcap
```
