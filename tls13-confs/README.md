TLS 1.3
===

## Build

```bash
wget https://github.com/wolfSSL/wolfssl/archive/v4.4.0-stable.tar.gz
tar -zxf v4.4.0-stable.tar.gz
cd wolfssl-4.4.0-stable
./autogen.sh && \
    ./configure --enable-tls13 --enable-hc128 --enable-rabbit --enable-aesccm \
                --enable-dtls --enable-dtls-mtu && \
    make && make install
```

## Start!

### TLS 1.3

```bash
# Handshake
alice# ./examples/server/server -l TLS13-CHACHA20-POLY1305-SHA256 -b -p 8080 -v 4 -1 0 -f -c /etc/ipsec.d/certs/aliceEcc256Cert.pem -k /etc/ipsec.d/private/aliceEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
  bob# ./examples/client/client -h 172.17.0.2 -p 8080 -v 4 -1 0 -f -c /etc/ipsec.d/certs/bobEcc256Cert.pem -k /etc/ipsec.d/private/bobEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem

alice# ./examples/server/server -l TLS13-CHACHA20-POLY1305-SHA256 -C 10 -b -p 8080 -v 4 -1 0 -f -c /etc/ipsec.d/certs/aliceEcc256Cert.pem -k /etc/ipsec.d/private/aliceEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
  bob# ./examples/client/client -h 172.17.0.2 -p 8080 -b 10 -v 4 -1 0 -f -c /etc/ipsec.d/certs/bobEcc256Cert.pem -k /etc/ipsec.d/private/bobEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem

# Communication
alice# ./examples/server/server -l TLS13-CHACHA20-POLY1305-SHA256 -B 4194304 -b -p 8080 -v 4 -1 0 -f -c /etc/ipsec.d/certs/aliceEcc256Cert.pem -k /etc/ipsec.d/private/aliceEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
  bob# ./examples/client/client -h 172.17.0.2 -p 8080 -B 4194304 -v 4 -1 0 -f -c /etc/ipsec.d/certs/bobEcc256Cert.pem -k /etc/ipsec.d/private/bobEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
```

### TLS 1.2

```bash
# Handshake
alice# ./examples/server/server -l ECDHE-ECDSA-CHACHA20-POLY1305 -b -p 8080 -v 3 -1 0 -f -c /etc/ipsec.d/certs/aliceEcc256Cert.pem -k /etc/ipsec.d/private/aliceEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
  bob# ./examples/client/client -h 172.17.0.2 -p 8080 -v 3 -1 0 -f -c /etc/ipsec.d/certs/bobEcc256Cert.pem -k /etc/ipsec.d/private/bobEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
```

### DTLS 1.2

```bash
# Handshake
alice# ./examples/server/server -l ECDHE-ECDSA-CHACHA20-POLY1305 -b -p 8080 -u -1 0 -f -c /etc/ipsec.d/certs/aliceEcc256Cert.pem -k /etc/ipsec.d/private/aliceEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
  bob# ./examples/client/client -h 172.17.0.2 -p 8080 -u -1 0 -f -c /etc/ipsec.d/certs/bobEcc256Cert.pem -k /etc/ipsec.d/private/bobEcc256Key.pem -A /etc/ipsec.d/cacerts/caEcc256Cert.pem
```