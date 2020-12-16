# 2020.12.08

- Data size: 100 MB
- Link bit rate: 100 Mbps, 200 Mbps, ..., 1000 Mbps (1Gbps)

## TLS

(TBD)

### TLS 1.3

### TLS 1.2

### DTLS 1.2

## IPsec

- `./ipsec_1`
  - ESP Cipher: chacha20poly1305
  - On Home PC
- `./ipsec_2`
  - ESP Cipher: aes128gcm128-sha256
  - On Home PC
- `./ipsec_3`
  - ESP Cipher: aes128gcm128-sha256
  - On Home PC
- `./ipsec_4`
  - ESP Cipher: aes128gcm128-sha256
  - On Office PC

## MACsec

- `./macsec_1`
  - Cipher: AES-GCM-128
- `./macsec_2`
  - Cipher: AES-GCM-128
  - On Home PC

## No security protocols

- `./none_0`
  - Special case, 1Gbps to 30Gbps
