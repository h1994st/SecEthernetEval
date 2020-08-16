IPsec, strongSwan
===

## Key Preparation

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

## strongSwan Configurations

Reference: [host2host-transport](https://www.strongswan.org/testing/testresults/ikev2/host2host-transport/index.html)

## Start!

```bash
alice# ipsec start
bob# ipsec start

alice# ipsec up host-host

# Capture the traffic on the host machine (outside Docker)

alice# ipsec stop
bob# ipsec stop
```
