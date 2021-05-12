#!/bin/bash

# Start three Docker containers for Alice, Bob, and Charlie
docker-compose -f testbed.yml up -d

# Set up the authenticator Docker
docker run -it -d \
    --network none \
    --mac-address 02:42:ac:11:00:01 \
    --name=authenticator --hostname=authenticator \
    --privileged \
    h1994st/sec_eval

# Link Docker network namespaces to the system
echo "Link Docker network namespaces to the system"
alice_pid="$(docker inspect -f '{{.State.Pid}}' secetherneteval_alice_1)"
bob_pid="$(docker inspect -f '{{.State.Pid}}' secetherneteval_bob_1)"
charlie_pid="$(docker inspect -f '{{.State.Pid}}' secetherneteval_charlie_1)"
auth_pid="$(docker inspect -f '{{.State.Pid}}' authenticator)"

echo "PIDs:"
echo "  Alice: "$alice_pid
echo "  Bob: "$bob_pid
echo "  Charlie: "$charlie_pid
echo "  Authenticator: "$auth_pid

# this is needed, as the directory /var/run/netns may not exist
sudo ip netns add netns0
sudo ip netns del netns0

sudo ln -sf /proc/$alice_pid/ns/net /var/run/netns/alice
sudo ln -sf /proc/$bob_pid/ns/net /var/run/netns/bob
sudo ln -sf /proc/$charlie_pid/ns/net /var/run/netns/charlie
sudo ln -sf /proc/$auth_pid/ns/net /var/run/netns/authenticator

echo "Network namespaces:"
ip netns list

# Move all Docker virtual interfaces to the authenticator namespace
echo "Move all Docker virtual interfaces to the authenticator namespace"
veths=$(ip -o link show type veth | awk -F': ' '{print $2}' | awk -F '@' '{print $1}')
for veth_if in $veths
do
    echo "  "$veth_if
    sudo ip link set $veth_if netns authenticator
done

# Configure virtual interfaces
ALICE_EXEC="sudo ip netns exec alice"
BOB_EXEC="sudo ip netns exec bob"
CHARLIE_EXEC="sudo ip netns exec charlie"
AUTH_EXEC="sudo ip netns exec authenticator"

echo "Create a bridge device in the authenticator namespace"
$AUTH_EXEC ip link add br0 type bridge
$AUTH_EXEC ip link set br0 up

echo "Connect virtual interfaces with the bridge and enable them"
for veth_if in $veths
do
    $AUTH_EXEC ip link set $veth_if master br0
    $AUTH_EXEC ip link set $veth_if up
done

$AUTH_EXEC ip link

# Test the connections
echo "Test the connections"
echo "Ping Bob from Alice"
$ALICE_EXEC ping -c 1 172.50.1.3
echo "Ping Charlie from Alice"
$ALICE_EXEC ping -c 1 172.50.1.4
