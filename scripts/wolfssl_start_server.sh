#!/bin/bash

TLS_VERSION=$1
TLS_CIPHER=$2
N_TIMES=$3

echo "[TLS Server] Run wolfSSL example server at port 8080"
echo "[TLS Server] TLS version:" $TLS_VERSION
echo "[TLS Server] TLS cipher:" $TLS_CIPHER
cd /home/seceth/wolfssl-4.4.0-stable
./examples/server/server \
    -l $TLS_CIPHER -b -p 8080 -v $TLS_VERSION -1 0 -f -C $N_TIMES \
    -c /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem \
    -k /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem \
    -A /code/ipsec-strongswan-confs/caEcc256Cert.pem &
# Wait for wolfSSL example server to start
echo "[TLS Server] Wait for the completion ..."
until pids=$(pidof server)
do
    sleep 1
done
echo "[TLS Server] Done!"
