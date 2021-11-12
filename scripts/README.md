# Helper Scrips

- Working directory: the root directory of `SecEthernetEval` repo, not `scripts` directory

## Scalability Testbed

Goal: evaluating the scalability of Gatekeeper

```bash
# num: the total number of containers in the network
./scripts/host_start_scalability_testbed.sh 2  # s1r1
./scripts/host_start_scalability_testbed.sh 3  # s1r2
./scripts/host_start_scalability_testbed.sh 5  # s1r4
./scripts/host_start_scalability_testbed.sh 9  # s1r8
./scripts/host_start_scalability_testbed.sh 17  # s1r16
./scripts/host_start_scalability_testbed.sh 33  # s1r32

docker-compose exec -u root --index=1 -w /code -- alice /code/udp_client -b -i eth0 /code/data/can_frames.pcap > ./results/scalability/20211111_1/s1r2/can_base/send.txt
docker-compose exec --index=2 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r2/can_base/recv1.txt
docker-compose exec --index=3 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r2/can_base/recv2.txt

docker-compose exec --index=4 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r4/can_base/recv3.txt
docker-compose exec --index=5 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r4/can_base/recv4.txt

docker-compose exec --index=6 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r8/can_base/recv5.txt
docker-compose exec --index=7 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r8/can_base/recv6.txt
docker-compose exec --index=8 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r8/can_base/recv7.txt
docker-compose exec --index=9 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r8/can_base/recv8.txt

docker-compose exec --index=10 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv9.txt
docker-compose exec --index=11 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv10.txt
docker-compose exec --index=12 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv11.txt
docker-compose exec --index=13 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv12.txt
docker-compose exec --index=14 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv13.txt
docker-compose exec --index=15 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv14.txt
docker-compose exec --index=16 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv15.txt
docker-compose exec --index=17 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r16/can_base/recv16.txt

docker-compose exec --index=18 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv17.txt
docker-compose exec --index=19 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv18.txt
docker-compose exec --index=20 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv19.txt
docker-compose exec --index=21 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv20.txt
docker-compose exec --index=22 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv21.txt
docker-compose exec --index=23 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv22.txt
docker-compose exec --index=24 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv23.txt
docker-compose exec --index=25 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv24.txt
docker-compose exec --index=26 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv25.txt
docker-compose exec --index=27 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv26.txt
docker-compose exec --index=28 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv27.txt
docker-compose exec --index=29 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv28.txt
docker-compose exec --index=30 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv29.txt
docker-compose exec --index=31 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv30.txt
docker-compose exec --index=32 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv31.txt
docker-compose exec --index=33 -w /code -- alice /code/udp_server > ./results/scalability/20211111_1/s1r32/can_base/recv32.txt

./scripts/host_stop_scalability_testbed.sh
```

(TODO: add descriptions of all other scripts to this file)
