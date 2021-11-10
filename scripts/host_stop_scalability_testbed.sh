#!/bin/bash

# Cleanup network namespaces
echo "[+] Cleanup network namespaces"
sudo rm -f /var/run/netns/alice_[0-9]*
sudo rm -f /var/run/netns/authenticator
ip netns list

# Stop and remove authenticator container
echo "[+] Stop and remove authenticator container"
docker stop authenticator
docker rm authenticator

# Stop other containers
echo "[+] Stop other containers"
docker-compose -f scalability_testbed.yml down
