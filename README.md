## Docker Configurations

- Alice: 172.17.0.2
- Bob: 172.17.0.3

```bash
docker run -it -d --name=alice --hostname=alice \
           --network=bridge \
           --volume /var/run/dbus:/var/run/dbus \
           --volume `pwd`:/code \
           --privileged ubuntu:18.04
docker run -it -d --name=bob --hostname=bob \
           --network=bridge \
           --volume /var/run/dbus:/var/run/dbus \
           --volume `pwd`:/code \
           --privileged ubuntu:18.04

docker exec -it alice /bin/bash
docker exec -it bob /bin/bash
```

### Prerequisites

```bash
sudo apt update
sudo apt install -y vim wget git autoconf libtool make apt-utils pkg-config \
                    libpq-dev libnl-3-dev libnl-genl-3-dev libnl-route-3-dev \
                    libssl-dev libdbus-1-dev network-manager \
                    iproute2 bsdmainutils iperf3 \
                    strongswan libcharon-extra-plugins strongswan-pki \
                    libgmp-dev iptables module-init-tools
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
  bob# iperf3 -c 172.17.0.2 -p 8080 -i 1 -d -4 -n 4096000000
```
