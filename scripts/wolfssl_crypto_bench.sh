#!/bin/bash

# Start two Docker containers for Alice and Bob
docker-compose up -d

docker-compose exec alice \
    /home/seceth/wolfssl-4.4.0-stable/wolfcrypt/benchmark/benchmark \
    -rsa_sign 1024

# Stop Docker
docker-compose down
