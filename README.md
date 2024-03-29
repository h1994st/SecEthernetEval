# Gatekeeper Evaluation

## Docker Configurations

- Alice: 172.50.1.2
- Bob: 172.50.1.3

### Docker image

```bash
docker pull h1994st/sec_eval
```

#### CHANGELOG

- 0.5.2: update wolfSSL library to commit `e5caf5124cf971553933b9c85cfabb6b5027b884`
- 0.5.1: update wolfSSL library to commit `8c178118a40d289aa573aeacf98c656a73024f5a`
- 0.5: include `vsomeip`
- 0.4.1: enable the OpenSSL compability layer of wolfSSL and rebuild `iperf3` with wolfSSL
- 0.4: install `netcat`, `tcpdump`, `can-utils`, and `libpcap`
- 0.3.1: add IPsec certificate into the container
- 0.3: finalize `iperf3` with wolfSSL
- 0.2.2: add a modified version of `iperf3` that uses wolfSSL
- 0.2.1: fix a bug in `hostapd` so that `CONFIG_L2_PACKET` is enabled, and `l2_packet_linux.c` is included in the program
- 0.2: include `hostapd`
- 0.1: integrate WolfSSL v4.4.0, wpa_supplicant 2.9, strongSwan and iperf3

### Docker compose

```bash
ln -s ./confs/<...>.yml docker-compose.yml  # select a configuration file
docker-compose up -d

docker-compose exec alice /code/scripts/config.sh
docker-compose exec bob /code/scripts/config.sh

docker-compose down
```

### Run Docker containers

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
  bob# iperf3 -c 172.50.1.2 -p 8080 -i 60 -4 -n 104857600 -b 0
```

## Performance Analysis

```bash
# inspect Docker cgroup
systemd-cgtop
# or
# the following command outputs Container ID
# ==> `docker/<Container Id>` is what we want
docker inspect -f "{{.Id}}" <Docker container name>

# collect performance profile for 100 seconds
sudo perf record -o <name.data> -a -F 199 -g -e cycles -G docker/<Container Id> -- sleep 100
sudo chown h1994st:h1994st <name.data>

# generate flamegraph
./results/perf_flame_graph/gen_svg.sh <name>
```

References:

- <http://www.brendangregg.com/Slides/LISA2017_Container_Performance_Analysis.pdf>
- <http://www.brendangregg.com/blog/2014-11-09/differential-flame-graphs.html>
