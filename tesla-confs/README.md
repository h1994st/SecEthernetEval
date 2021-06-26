# TESLA

## Setup

1. Build Evaluation Applications on host machine
2. Copy `tesla_udp_client`, `tesla_udp_server`, and `libtesla.so` to the root of `SecEthernetEval`
    - TODO: better compile these applications while building the Docker container
3. Copy `libtesla.so` to `/usr/local/lib`: `sudo cp libtesla.so /usr/local/lib`
4. Enter the Docker container and refresh the dynamic linker: `sudo ldconfig`
5. (Optional) Check if `libtesla.so` is located succesfully: `ldd /code/tesla_udp_client`

    ```text
    linux-vdso.so.1 (0x00007fff4daf6000)
    libpcap.so.0.8 => /usr/lib/x86_64-linux-gnu/libpcap.so.0.8 (0x00007ff2dabac000)
    libtesla.so => /usr/local/lib/libtesla.so (0x00007ff2da9a3000)
    libwolfssl.so.24 => /usr/local/lib/libwolfssl.so.24 (0x00007ff2da6bb000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff2da2ca000)
    libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007ff2d9f2c000)
    libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007ff2d9d0d000)
    /lib64/ld-linux-x86-64.so.2 (0x00007ff2daff2000)
    ```

### TL;DR

Assuming `tesla_udp_client`, `tesla_udp_server`, and `libtesla.so` are in the rood of `SecEthernetEval`:

```bash
sudo cp libtesla.so /usr/local/lib
sudo ldconfig
ldd /code/tesla_udp_client
```

## Start

Run `tesla_udp_client` on `alice` at first. Then, run `tesla_udp_server` on `bob`.

```bash
alice# ./tesla_udp_client -b -f /code/data/privkey.pem /code/data/can_frames.pcap

  bob# ./tesla_udp_server /code/data/pubkey.pem
```
