# TLS 1.3

## Build

```bash
wget https://github.com/wolfSSL/wolfssl/archive/v4.4.0-stable.tar.gz
tar -zxf v4.4.0-stable.tar.gz
cd wolfssl-4.4.0-stable
./autogen.sh
./configure --enable-tls13 --enable-tlsv10 --enable-oldtls --enable-dtls \
            --enable-dtls-mtu --enable-hc128 --enable-rabbit \
            --enable-aesccm --enable-opensslall && \
make && make install
```

## Start

### Host Scripts

```bash
# TLS 1.3
bash scripts/tls_eval_handshake.sh 20 <docker bridge> 4 TLS13-AES128-GCM-SHA256 <results dir>

# TLS 1.2
bash scripts/tls_eval_handshake.sh 20 <docker bridge> 3 ECDHE-ECDSA-AES128-GCM-SHA256 <results dir>

# DTLS 1.2
bash scripts/dtls_eval_handshake.sh 20 <docker bridge> <results dir>
```

### iperf+wolfssl

```bash
alice# ./iperf-wolfssl/src/iperf3 -s -p 8080 --ssl-tls-version 1.3 --ssl-server-key /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem --ssl-server-cert /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem --ssl-suites-file /code/tls13-confs/ciphers.txt
  bob# ./iperf-wolfssl/src/iperf3 -c 172.50.1.2 -p 8080 -n 500M -4 --ssl-tls-version 1.3 --ssl-client-cert /code/ipsec-strongswan-confs/caEcc256Cert.pem --ssl-suites-file /code/tls13-confs/ciphers.txt
```

### TLS 1.3

```bash
# Handshake
alice# ./wolfssl-4.4.0-stable/examples/server/server -l TLS13-AES128-GCM-SHA256 -b -p 8080 -v 4 -f -c /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem -k /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
  bob# ./wolfssl-4.4.0-stable/examples/client/client -h 172.50.1.2 -p 8080 -v 4 -f -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
  bob# ./wolfssl-4.4.0-stable/examples/client/client -Y -l TLS13-AES128-GCM-SHA256 -h 172.50.1.2 -p 8080 -v 4 -f -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem

# Handshake 10 times
alice# ./wolfssl-4.4.0-stable/examples/server/server -l TLS13-AES128-GCM-SHA256 -C 10 -b -p 8080 -v 4 -f -c /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem -k /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
  bob# ./wolfssl-4.4.0-stable/examples/client/client -h 172.50.1.2 -p 8080 -b 10 -v 4 -f -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem

# Communication
alice# ./wolfssl-4.4.0-stable/examples/server/server -l TLS13-AES128-GCM-SHA256 -B 104857600 -b -p 8080 -v 4 -f -c /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem -k /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
  bob# ./wolfssl-4.4.0-stable/examples/client/client -h 172.50.1.2 -p 8080 -B 104857600 -v 4 -f -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem

# Benchmark
alice# ./wolfssl-4.4.0-stable/examples/benchmark/tls_bench -s -h 172.50.1.2 -P 8080 -l TLS13-AES128-GCM-SHA256 -p 16384 -S 52428800 -v
  bob# ./wolfssl-4.4.0-stable/examples/benchmark/tls_bench -c -h 172.50.1.2 -P 8080 -l TLS13-AES128-GCM-SHA256 -p 16384 -S 52428800 -v
```

### TLS 1.2

```bash
# Handshake
alice# ./wolfssl-4.4.0-stable/examples/server/server -l ECDHE-ECDSA-AES128-GCM-SHA256 -b -p 8080 -v 3 -f -c /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem -k /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
  bob# ./wolfssl-4.4.0-stable/examples/client/client -h 172.50.1.2 -p 8080 -v 3 -f -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
```

### DTLS 1.2

```bash
# Handshake
alice# ./wolfssl-4.4.0-stable/examples/server/server -l ECDHE-ECDSA-AES128-GCM-SHA256 -b -p 8080 -u -f -c /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem -k /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
  bob# ./wolfssl-4.4.0-stable/examples/client/client -h 172.50.1.2 -p 8080 -u -f -c /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem -k /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem -A /code/ipsec-strongswan-confs/caEcc256Cert.pem
```
