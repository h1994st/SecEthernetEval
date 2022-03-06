#!/bin/bash

TARGET_DEV=$1

# Assume the following line has been executed
# sudo insmod mitm_recv_dos.ko

# Configure virtual interfaces
AUTH_EXEC="sudo ip netns exec authenticator"

# Authenticator: mitm_recv_dos
echo "Authenticator: mitm_recv_dos"
sudo ip link set mitm_recv_dos netns authenticator

$AUTH_EXEC ip link set br0 down
$AUTH_EXEC ip link set $TARGET_DEV down
$AUTH_EXEC ip link set $TARGET_DEV nomaster
$AUTH_EXEC ip link set mitm_recv_dos up
sudo sh -c "printf $TARGET_DEV > /sys/kernel/debug/mitm_recv_dos/slave"
$AUTH_EXEC ip link set mitm_recv_dos master br0
# $AUTH_EXEC ip addr add 172.50.1.1/24 brd + dev mitm_auth
# $AUTH_EXEC ip addr flush dev $TARGET_DEV
$AUTH_EXEC ip addr
$AUTH_EXEC ip link set br0 up
$AUTH_EXEC ip link
