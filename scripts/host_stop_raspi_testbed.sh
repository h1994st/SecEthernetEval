#!/bin/bash

# Cleanup network namespaces
echo "Cleanup network namespaces"
sudo rm -f /var/run/netns/alice
sudo rm -f /var/run/netns/bob
ip netns list

# Stop other containers: Alice, Bob
echo "Stop containers"
docker-compose -f raspi_testbed.yml down
