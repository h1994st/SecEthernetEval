#!/bin/bash

SERVER_IP_ADDR=$1
DTLS_VERSION=$2
DTLS_CIPHER=$3

echo "[DTLS Client] Run wolfSSL example client"
echo "[DTLS Client] DTLS version:" $DTLS_VERSION
echo "[DTLS Client] DTLS cipher:" $DTLS_CIPHER
cd ./wolfssl-4.4.0-stable/examples
./client/client -h $SERVER_IP_ADDR -p 8080 \
    -u -v $DTLS_VERSION -f -b 1 \
    -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem \
    -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem \
    -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
echo "[DTLS Client] Done!"
