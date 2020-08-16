## Docker Configurations

- Alice: 172.17.0.3
- Bob: 172.17.0.2

### Prerequisites

```bash
sudo apt update
sudo apt install wget git autoconf libtool make libpq-dev \
                 iproute2 netcat telnet bsdmainutils iperf3 nmap \
                 strongswan libcharon-extra-plugins strongswan-pki \
                 libgmp-dev iptables module-init-tools \
```

## Traffic Control & Generator

### Control Bandwidth and Delay

```bash
tc qdisc add dev eth0 handle 1: root htb default 11
tc class add dev eth0 parent 1: classid 1:1 htb rate 1000Mbps
tc class add dev eth0 parent 1:1 classid 1:11 htb rate 100Mbit
tc qdisc add dev eth0 parent 1:11 handle 10: netem delay 50ms

tc qdisc del dev eth0 root
```

### Network Performance Measurement

```bash
alice# iperf3 -s -d -p 8080
bob# iperf3 -c 172.17.0.3 -p 8080 -i 1 -d -4 -n 4096000000

```
