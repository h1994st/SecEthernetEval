#!/bin/bash

# Cleanup network namespaces
echo "Cleanup network namespaces"
sudo rm -f /var/run/netns/alice
sudo rm -f /var/run/netns/bob
sudo rm -f /var/run/netns/charlie
sudo rm -f /var/run/netns/authenticator
ip netns list

# Stop and remove authenticator container
echo "Stop and remove authenticator container"
docker stop authenticator
docker rm authenticator

# Stop other containers: Alice, Bob, and Charlie
echo "Stop other containers"
docker-compose -f testbed.yml down
