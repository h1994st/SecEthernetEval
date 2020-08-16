MACsec
===

## Key Preparation

```bash
# Generate a 128-bit key
dd if=/dev/urandom count=16 bs=1 2>/dev/null | hexdump | cut -c 9- | tr -d ' \n' > aliceKey128.txt
dd if=/dev/urandom count=16 bs=1 2>/dev/null | hexdump | cut -c 9- | tr -d ' \n' > bobKey128.txt
```

## Configurations

### Alice

Reference: [MACsec: a different solution to encrypt network traffic](https://developers.redhat.com/blog/2016/10/14/macsec-a-different-solution-to-encrypt-network-traffic/)

```bash
export ALICE_MAC=02:42:ac:11:00:03
export ALICE_KEY_128=`cat aliceKey128.txt`
export BOB_MAC=02:42:ac:11:00:02
export BOB_KEY_128=`cat bobKey128.txt`

ip link add link eth0 macsec0 type macsec encrypt on
ip macsec add macsec0 rx port 1 address $BOB_MAC

# Configure the TX key
# - KEY: alice's key, key id is "00"
ip macsec add macsec0 tx sa 0 pn 1 on key 00 $ALICE_KEY_128
# Configure the RX key
# - SCI, including Bob's MAC address
# - sa & OPTS
# - KEY: bob's key, key id is "01"
ip macsec add macsec0 rx port 1 address $BOB_MAC \
                         sa 0 pn 1 on \
                         key 01 $BOB_KEY_128
```

### Bob

```bash
export ALICE_MAC=02:42:ac:11:00:03
export ALICE_KEY_128=`cat aliceKey128.txt`
export BOB_MAC=02:42:ac:11:00:02
export BOB_KEY_128=`cat bobKey128.txt`

ip link add link eth0 macsec0 type macsec encrypt on
ip macsec add macsec0 rx port 1 address $ALICE_MAC

# Configure the TX key
# - KEY: bob's key, key id is "01"
ip macsec add macsec0 tx sa 0 pn 1 on key 01 $BOB_KEY_128
# Configure the RX key
# - SCI, including Alice's MAC address
# - sa & OPTS
# - KEY: alice's key, key id is "00"
ip macsec add macsec0 rx port 1 address 02:42:ac:11:00:03 \
                         sa 0 pn 1 on \
                         key 00 $ALICE_KEY_128
```

## Start!

```bash
alice# ip link set macsec0 up
alice# ip addr add 10.1.0.1/24 dev macsec0

  bob# ip link set macsec0 up
  bob# ip addr add 10.1.0.2/24 dev macsec0

# Capture the traffic on the host machine (outside Docker)

# Need to change the ip address
alice# iperf3 -s -d -p 8080
  bob# iperf3 -c 10.1.0.1 -p 8080 -i 1 -d -4 -n 4096000000

alice# ip link set macsec0 down
  bob# ip link set macsec0 down
```
