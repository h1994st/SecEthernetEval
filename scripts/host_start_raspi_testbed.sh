#!/bin/bash

ALICE_ETH_IF=enp5s0
BOB_ETH_IF=enx000ec6a11196

# for Raspberry Pi
# Please refer to ./raspi-confs/README.md
# sudo ip addr add 172.50.1.2/24 brd + dev br0

# Start three Docker containers for Alice, Bob
docker-compose -f raspi_testbed.yml up -d

# Link Docker network namespaces to the system
echo "Link Docker network namespaces to the system"
alice_pid="$(docker inspect -f '{{.State.Pid}}' secetherneteval_alice_1)"
bob_pid="$(docker inspect -f '{{.State.Pid}}' secetherneteval_bob_1)"

echo "PIDs:"
echo "  Alice: "$alice_pid
echo "  Bob: "$bob_pid

# this is needed, as the directory /var/run/netns may not exist
sudo ip netns add netns0
sudo ip netns del netns0

sudo ln -sf /proc/$alice_pid/ns/net /var/run/netns/alice
sudo ln -sf /proc/$bob_pid/ns/net /var/run/netns/bob

echo "Network namespaces:"
ip netns list

# Move two ethernet interfaces to two container namespace
echo "Move "$ALICE_ETH_IF" to alice"
sudo ip link set $ALICE_ETH_IF netns alice
echo "Move "$BOB_ETH_IF" to bob"
sudo ip link set $BOB_ETH_IF netns bob

# Configure ethernet interfaces
ALICE_EXEC="sudo ip netns exec alice"
BOB_EXEC="sudo ip netns exec bob"

echo "Set IP addresses"
$ALICE_EXEC ip addr add 172.50.1.2/24 brd + dev $ALICE_ETH_IF
$ALICE_EXEC ip addr
$BOB_EXEC ip addr add 172.50.1.3/24 brd + dev $BOB_ETH_IF
$BOB_EXEC ip addr

echo "Enable ethernet interfaces"
$ALICE_EXEC ip link set $ALICE_ETH_IF up
$BOB_EXEC ip link set $BOB_ETH_IF up

echo "Wait 3 seconds ..."
sleep 3

# Test the connections
echo "Test the connections"
echo "Ping Bob from Alice"
$ALICE_EXEC ping -c 1 172.50.1.3
echo "Ping Bob from Alice"
$BOB_EXEC ping -c 1 172.50.1.2
