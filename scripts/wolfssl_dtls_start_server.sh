#!/bin/bash

DTLS_VERSION=$1
DTLS_CIPHER=$2
N_TIMES=$3

echo "[DTLS Server] Run wolfSSL example server at port 8080"
echo "[DTLS Server] DTLS version:" $DTLS_VERSION
echo "[DTLS Server] DTLS cipher:" $DTLS_CIPHER
cd /home/seceth/wolfssl-4.4.0-stable
./examples/server/server \
    -l $DTLS_CIPHER -b -p 8080 -u -v $DTLS_VERSION -1 0 -f -C $N_TIMES \
    -c /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem \
    -k /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem \
    -A /code/ipsec-strongswan-confs/caEcc256Cert.pem &
# Wait for wolfSSL example server to start
echo "[DTLS Server] Wait for the completion ..."
until pids=$(pidof server)
do
    sleep 1
done
echo "[DTLS Server] Done!"
