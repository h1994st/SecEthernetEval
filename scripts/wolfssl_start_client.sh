#!/bin/bash

SERVER_IP_ADDR=$1
TLS_VERSION=$2
TLS_CIPHER=$3

echo "[TLS Client] Run wolfSSL example client"
echo "[TLS Server] TLS version:" $TLS_VERSION
echo "[TLS Server] TLS cipher:" $TLS_CIPHER
cd ./wolfssl-4.4.0-stable/examples
./client/client -h $SERVER_IP_ADDR -p 8080 \
    -v $TLS_VERSION -f -b 1 \
    -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem \
    -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem \
    -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
echo "[TLS Client] Done!"
