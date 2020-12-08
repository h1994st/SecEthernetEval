# Secure Ethernet Performance Evaluation

## Docker Configurations

- Alice: 172.50.1.2
- Bob: 172.50.1.3

### Docker compose

```bash
docker pull h1994st/sec_eval
docker-compose up -d

docker-compose exec alice /code/scripts/config.sh
docker-compose exec bob /code/scripts/config.sh

docker-compose down
```

### Docker

```bash
docker run -it -d --name=alice --hostname=alice \
           --network=bridge \
           --volume /var/run/dbus:/var/run/dbus \
           --volume `pwd`:/code \
           --privileged h1994st/sec_eval
docker run -it -d --name=bob --hostname=bob \
           --network=bridge \
           --volume /var/run/dbus:/var/run/dbus \
           --volume `pwd`:/code \
           --privileged h1994st/sec_eval

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
# 100 Mbit link
tc qdisc add dev eth0 handle 1: root htb default 11
tc class add dev eth0 parent 1: classid 1:1 htb rate 100Mbit
tc class add dev eth0 parent 1:1 classid 1:11 htb rate 100Mbit

# 1 Gbit link
tc qdisc add dev eth0 handle 1: root htb default 11
tc class add dev eth0 parent 1: classid 1:1 htb rate 1Gbit
tc class add dev eth0 parent 1:1 classid 1:11 htb rate 1Gbit

# delay
tc qdisc add dev eth0 parent 1:11 handle 10: netem delay 50ms

# delete
tc qdisc del dev eth0 root
```

### Network Performance Measurement

```bash
alice# iperf3 -s -d -p 8080
  bob# iperf3 -c 172.50.1.2 -p 8080 -i 1 -d -4 --get-server-output -n 104857600
```
