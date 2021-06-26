#!/bin/bash

# Assume the following line has been executed
# sudo insmod mitm_auth.ko

# Configure virtual interfaces
AUTH_EXEC="sudo ip netns exec authenticator"

# Authenticator: mitm_auth
echo "Authenticator: mitm_auth"
sudo ip link set mitm_auth netns authenticator

$AUTH_EXEC ip link set br0 down
$AUTH_EXEC ip link set mitm_auth up
sudo sh -c 'printf br0 > /sys/kernel/debug/mitm_auth/slave'
$AUTH_EXEC ip addr add 172.50.1.1/24 brd + dev mitm_auth
# $AUTH_EXEC ip addr flush dev br0
$AUTH_EXEC ip addr
