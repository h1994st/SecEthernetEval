```bash
sudo cp libtesla.so /usr/local/lib
sudo ldconfig
ldd /code/tesla_udp_client

# can over udp
./udp_server
./udp_client -b /code/data/can_frames.pcap
sudo ./udp_client -i mitm_snd -b /code/data/can_frames.pcap

./tesla_udp_server /code/data/pubkey.pem 172.50.1.2
./tesla_udp_client -b -f /code/data/privkey.pem /code/data/can_frames.pcap

# lidar udp replay
./lidar_udp_server
./lidar_udp_client -b /code/data/lidar_pcaps/HDL32-V2_Tunnel.pcap
sudo ./lidar_udp_client -i mitm_snd -b /code/data/lidar_pcaps/HDL32-V2_Tunnel.pcap

./tesla_lidar_udp_server /code/data/pubkey.pem 172.50.1.2
./tesla_lidar_udp_client -b -f /code/data/privkey.pem /code/data/lidar_pcaps/HDL32-V2_Tunnel.pcap
```

## Setup

```bash
# in docker
sudo cp libtesla.so /usr/local/lib
sudo ldconfig
ldd /code/tesla_udp_client

cp can_udp/udp_client can_udp/udp_server \
   can_udp_raw/udp_client_raw can_udp_raw/udp_server_raw \
   tesla_can_udp/tesla_udp_client tesla_can_udp/tesla_udp_server \
   lidar_udp/lidar_udp_client lidar_udp/lidar_udp_server \
   lidar_udp_raw/lidar_udp_client_raw lidar_udp_raw/lidar_udp_server_raw \
   tesla_lidar_udp/tesla_lidar_udp_client tesla_lidar_udp/tesla_lidar_udp_server \
   <path/to/SecEthernetEval>
```

## CAN over UDP

```bash
# Baseline
./udp_client -b /code/data/can_frames.pcap > /code/results/broadcast_protection/20210626_2/can_udp_base/send.txt
./udp_server > /code/results/broadcast_protection/20210626_2/can_udp_base/recv.txt


# Gatekeeper
sudo ./udp_client_raw -i eth0 -b /code/data/can_frames.pcap > /code/results/broadcast_protection/20210626_2/can_udp_protection/send.txt
sudo ./udp_server_raw > /code/results/broadcast_protection/20210626_2/can_udp_protection/recv.txt

# TESLA
./tesla_udp_client -b -f /code/data/privkey.pem /code/data/can_frames.pcap > /code/results/broadcast_protection/20210626_2/can_udp_tesla/send.txt
./tesla_udp_server /code/data/pubkey.pem 172.50.1.2 > /code/results/broadcast_protection/20210626_2/can_udp_tesla/recv.txt
```

## LiDAR Replay

```bash
# Baseline
./lidar_udp_client -b /code/data/lidar_pcaps/HDL32-V2_Tunnel.pcap > /code/results/broadcast_protection/20210626_2/lidar_replay_base/send.txt
./lidar_udp_server > /code/results/broadcast_protection/20210626_2/lidar_replay_base/recv.txt

# Gatekeeper
sudo ./lidar_udp_client_raw -i eth0 -b /code/data/lidar_pcaps/HDL32-V2_Tunnel.pcap > /code/results/broadcast_protection/20210626_2/lidar_replay_protection/send.txt
sudo ./lidar_udp_server_raw > /code/results/broadcast_protection/20210626_2/lidar_replay_protection/recv.txt

# TESLA
./tesla_lidar_udp_client -b -f /code/data/privkey.pem /code/data/lidar_pcaps/HDL32-V2_Tunnel.pcap > /code/results/broadcast_protection/20210626_2/lidar_replay_tesla/send.txt
./tesla_lidar_udp_server /code/data/pubkey.pem 172.50.1.2 > /code/results/broadcast_protection/20210626_2/lidar_replay_tesla/recv.txt
```
