#!/bin/bash

# Assume the following lines have been executed
# sudo insmod mitm_snd.ko
# sudo insmod mitm_recv.ko
# sudo insmod mitm_auth.ko

# Configure virtual interfaces
ALICE_EXEC="sudo ip netns exec alice"
BOB_EXEC="sudo ip netns exec bob"
# CHARLIE_EXEC="sudo ip netns exec charlie"
AUTH_EXEC="sudo ip netns exec authenticator"

# Alice: mitm_snd
echo "Alice: mitm_snd"
sudo ip link set mitm_snd netns alice

$ALICE_EXEC ip link set eth0 down
$ALICE_EXEC ip link set mitm_snd up
sudo sh -c 'printf eth0 > /sys/kernel/debug/mitm_snd/slave'
$ALICE_EXEC ip addr add 172.50.1.2/24 brd + dev mitm_snd
$ALICE_EXEC ip addr flush dev eth0
$ALICE_EXEC ip addr

# Bob: mitm_recv
echo "Bob: mitm_recv"
sudo ip link set mitm_recv netns bob

$BOB_EXEC ip link set eth0 down
$BOB_EXEC ip link set mitm_recv up
sudo sh -c 'printf eth0 > /sys/kernel/debug/mitm_recv/slave'
$BOB_EXEC ip addr add 172.50.1.3/24 brd + dev mitm_recv
$BOB_EXEC ip addr flush dev eth0
$BOB_EXEC ip addr

# Authenticator: mitm_auth
echo "Authenticator: mitm_auth"
sudo ip link set mitm_auth netns authenticator

$AUTH_EXEC ip link set br0 down
$AUTH_EXEC ip link set mitm_auth up
sudo sh -c 'printf br0 > /sys/kernel/debug/mitm_auth/slave'
$AUTH_EXEC ip addr add 172.50.1.1/24 brd + dev mitm_auth
# $AUTH_EXEC ip addr flush dev br0
$AUTH_EXEC ip addr
