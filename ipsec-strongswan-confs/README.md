# IPsec, strongSwan

## Key Preparation

Reference: [Setting-up a Simple CA Using the strongSwan PKI Tool](https://wiki.strongswan.org/projects/strongswan/wiki/SimpleCA)

### RSA 2048

```bash
pki --gen > caKey.der
pki --self --in caKey.der --dn "C=CH, O=robustnet, CN=robustnet Root CA" --ca > caCert.der
openssl x509 -inform der -outform pem -in caCert.der -out caCert.pem
openssl rsa -inform der -outform pem -in caKey.der -out caKey.pem

pki --gen > aliceRsaKey.der
pki --issue --in aliceRsaKey.der --type priv --cacert caCert.der --cakey caKey.der \
            --dn "C=CH, O=robustnet, CN=alice.robustnet.eecs.umich.edu" \
            --san alice.robustnet.eecs.umich.edu > aliceRsaCert.der
openssl x509 -inform der -outform pem -in aliceRsaCert.der -out aliceRsaCert.pem
openssl rsa -inform der -outform pem -in aliceRsaKey.der -out aliceRsaKey.pem

pki --gen > bobRsaKey.der
pki --issue --in bobRsaKey.der --type priv --cacert caCert.der --cakey caKey.der \
            --dn "C=CH, O=robustnet, CN=bob.robustnet.eecs.umich.edu" \
            --san bob.robustnet.eecs.umich.edu > bobRsaCert.der
openssl x509 -inform der -outform pem -in bobRsaCert.der -out bobRsaCert.pem
openssl rsa -inform der -outform pem -in bobRsaKey.der -out bobRsaKey.pem
```

### ECC 256

```bash
pki --gen --type ecdsa --size 256 > caEcc256Key.der
pki --self --in caEcc256Key.der --dn "C=CH, O=robustnet, CN=robustnet Root CA" --ca > caEcc256Cert.der
openssl x509 -inform der -outform pem -in caEcc256Cert.der -out caEcc256Cert.pem
openssl ec -inform der -outform pem -in caEcc256Key.der -out caEcc256Key.pem

pki --gen --type ecdsa --size 256 > aliceEcc256Key.der
pki --issue --in aliceEcc256Key.der --type priv --cacert caEcc256Cert.der --cakey caEcc256Key.der \
            --dn "C=CH, O=robustnet, CN=alice.robustnet.eecs.umich.edu" \
            --san alice.robustnet.eecs.umich.edu > aliceEcc256Cert.der
openssl x509 -inform der -outform pem -in aliceEcc256Cert.der -out aliceEcc256Cert.pem
openssl ec -inform der -outform pem -in aliceEcc256Key.der -out aliceEcc256Key.pem

pki --gen --type ecdsa --size 256 > bobEcc256Key.der
pki --issue --in bobEcc256Key.der --type priv --cacert caEcc256Cert.der --cakey caEcc256Key.der \
            --dn "C=CH, O=robustnet, CN=bob.robustnet.eecs.umich.edu" \
            --san bob.robustnet.eecs.umich.edu > bobEcc256Cert.der
openssl x509 -inform der -outform pem -in bobEcc256Cert.der -out bobEcc256Cert.pem
openssl ec -inform der -outform pem -in bobEcc256Key.der -out bobEcc256Key.pem
```

## strongSwan Configurations

Reference: [host2host-transport](https://www.strongswan.org/testing/testresults/ikev2/host2host-transport/index.html)

### Key Files

```bash
cp /code/ipsec-strongswan-confs/alice/aliceRsaKey.pem /etc/ipsec.d/private
cp /code/ipsec-strongswan-confs/alice/aliceRsaCert.pem /etc/ipsec.d/certs
cp /code/ipsec-strongswan-confs/bob/bobRsaKey.pem /etc/ipsec.d/private
cp /code/ipsec-strongswan-confs/bob/bobRsaCert.pem /etc/ipsec.d/certs
cp /code/ipsec-strongswan-confs/caCert.pem /etc/ipsec.d/cacerts

cp /code/ipsec-strongswan-confs/alice/aliceEcc256Key.pem /etc/ipsec.d/private
cp /code/ipsec-strongswan-confs/alice/aliceEcc256Cert.pem /etc/ipsec.d/certs
cp /code/ipsec-strongswan-confs/bob/bobEcc256Key.pem /etc/ipsec.d/private
cp /code/ipsec-strongswan-confs/bob/bobEcc256Cert.pem /etc/ipsec.d/certs
cp /code/ipsec-strongswan-confs/caEcc256Cert.pem /etc/ipsec.d/cacerts
```

### Configuration Files

```bash
# For Alice
cp /code/ipsec-strongswan-confs/alice/ipsec.conf /etc
cp /code/ipsec-strongswan-confs/alice/ipsec.secrets /etc
cp /code/ipsec-strongswan-confs/alice/strongswan.conf /etc

# For Bob
cp /code/ipsec-strongswan-confs/bob/ipsec.conf /etc
cp /code/ipsec-strongswan-confs/bob/ipsec.secrets /etc
cp /code/ipsec-strongswan-confs/bob/strongswan.conf /etc
```

## Start

```bash
alice# ipsec start
  bob# ipsec start

alice# ipsec up host-host

# Capture the traffic on the host machine (outside Docker)

alice# ipsec stop
  bob# ipsec stop
```
