#!/bin/bash

NUM=$1

# Start Docker containers for ECUs
echo "[+] Start Docker containers for $NUM ECUs"
docker-compose -f scalability_testbed.yml up -d --scale alice=$NUM

# Set up the authenticator Docker
echo "[+] Start Docker containers for $NUM ECUs"
docker run -it -d \
    --network none \
    --name=authenticator --hostname=authenticator \
    --privileged \
    --cpus="0.06" \
    --cpuset-cpus=6 \
    h1994st/sec_eval

# Link Docker network namespaces to the system
echo "[+] Link Docker network namespaces to the system"

# this is needed, as the directory /var/run/netns may not exist
sudo ip netns add netns0
sudo ip netns del netns0

for i in `seq 1 $NUM` ;
do
    alice_pid="$(docker inspect -f '{{.State.Pid}}' secetherneteval_alice_$i)"
    sudo ln -sf /proc/$alice_pid/ns/net /var/run/netns/alice_$i
    echo "- Alice "$i": "$alice_pid
done

auth_pid="$(docker inspect -f '{{.State.Pid}}' authenticator)"
echo "- Authenticator: "$auth_pid
sudo ln -sf /proc/$auth_pid/ns/net /var/run/netns/authenticator

echo "[+] Network namespaces:"
ip netns list

# Move all Docker virtual interfaces to the authenticator namespace
echo "[+] Move all Docker virtual interfaces to the authenticator namespace"
veths=$(ip -o link show type veth | awk -F': ' '{print $2}' | awk -F '@' '{print $1}')
for veth_if in $veths
do
    echo "  "$veth_if
    sudo ip link set $veth_if netns authenticator
done

# Configure virtual interfaces
AUTH_EXEC="sudo ip netns exec authenticator"

echo "[+] Create a bridge device in the authenticator namespace"
$AUTH_EXEC ip link add br0 type bridge
$AUTH_EXEC ip link set br0 up

echo "[+] Connect virtual interfaces with the bridge and enable them"
for veth_if in $veths
do
    $AUTH_EXEC ip link set $veth_if master br0
    $AUTH_EXEC ip link set $veth_if up
done

$AUTH_EXEC ip -br link

for i in `seq 1 $NUM` ;
do
    ALICE_EXEC="sudo ip netns exec alice_$i"
    echo "- Alice "$i" IP/MAC: "
    $ALICE_EXEC ip -br a show dev eth0
    $ALICE_EXEC ip -br link show eth0
done
