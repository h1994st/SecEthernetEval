# MACsec

## Host Machine Configuration

The host machine must allow the forwarding of Ethernet multicast packets (i.e., PAE address).

```bash
sudo ip link set <bridge interface> type bridge group_fwd_mask 0x8
```

## Manual Configurations

### Key Preparation

```bash
# Generate a 128-bit key
dd if=/dev/urandom count=16 bs=1 2>/dev/null | hexdump | cut -c 9- | tr -d ' \n' > aliceKey128.txt
dd if=/dev/urandom count=16 bs=1 2>/dev/null | hexdump | cut -c 9- | tr -d ' \n' > bobKey128.txt
```

### Alice

Reference: [MACsec: a different solution to encrypt network traffic](https://developers.redhat.com/blog/2016/10/14/macsec-a-different-solution-to-encrypt-network-traffic/)

```bash
export ALICE_MAC=02:42:ac:11:00:02
export ALICE_KEY_128=`cat /code/macsec-confs/alice/aliceKey128.txt`
export BOB_MAC=02:42:ac:11:00:03
export BOB_KEY_128=`cat /code/macsec-confs/bob/bobKey128.txt`

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
export ALICE_MAC=02:42:ac:11:00:02
export ALICE_KEY_128=`cat /code/macsec-confs/alice/aliceKey128.txt`
export BOB_MAC=02:42:ac:11:00:03
export BOB_KEY_128=`cat /code/macsec-confs/bob/bobKey128.txt`

ip link add link eth0 macsec0 type macsec encrypt on
ip macsec add macsec0 rx port 1 address $ALICE_MAC

# Configure the TX key
# - KEY: bob's key, key id is "01"
ip macsec add macsec0 tx sa 0 pn 1 on key 01 $BOB_KEY_128
# Configure the RX key
# - SCI, including Alice's MAC address
# - sa & OPTS
# - KEY: alice's key, key id is "00"
ip macsec add macsec0 rx port 1 address $ALICE_MAC \
                         sa 0 pn 1 on \
                         key 00 $ALICE_KEY_128
```

### Start MACsec

```bash
alice# ip link set macsec0 up
alice# ip addr add 10.1.0.2/24 dev macsec0

  bob# ip link set macsec0 up
  bob# ip addr add 10.1.0.3/24 dev macsec0

# Capture the traffic on the host machine (outside Docker)

# Need to change the ip address
alice# iperf3 -s -d -p 8080
  bob# iperf3 -c 10.1.0.2 -p 8080 -i 1 -d -4 --get-server-output -n 104857600

alice# ip link set macsec0 down
alice# ip link delete macsec0
  bob# ip link set macsec0 down
  bob# ip link delete macsec0
```

## `wpa_supplicant`

Reference: [wpa_supplicant README](http://w1.fi/cgit/hostap/plain/wpa_supplicant/README)

```bash
wget http://w1.fi/releases/wpa_supplicant-2.9.tar.gz
tar -xzf wpa_supplicant-2.9.tar.gz
cd wpa_supplicant-2.9/wpa_supplicant
# Move `wpa_supplicant_build_config` to the current directory
# Rename it to `.config`
cp /code/macsec-confs/wpa_supplicant_build_config .config
make
make install
```

### Start `wpa_supplicant`

```bash
wpa_supplicant -i eth0 -D macsec_linux -c /code/macsec-confs/alice/wpa_supplicant.conf

wpa_supplicant -i eth0 -D macsec_linux -c /code/macsec-confs/bob/wpa_supplicant.conf
```

## `hostapd`

Reference: [hostapd README](http://w1.fi/cgit/hostap/plain/hostapd/README)

```bash
wget https://w1.fi/releases/hostapd-2.9.tar.gz
tar -xzf hostapd-2.9.tar.gz
cd hostapd-2.9/hostapd
# Move `hostapd_build_config` to the current directory
# Rename it to `.config`
cp /code/macsec-confs/hostapd_build_config .config
make
make install
```

### Start `hostapd`

```bash
cp /code/macsec-confs/alice/hostapd.eap_user /etc
hostapd /code/macsec-confs/alice/hostapd.conf
```
