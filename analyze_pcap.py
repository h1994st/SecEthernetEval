#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-08-17 23:24:15

import os
import sys

import dpkt


def main(pcap_filepath):
    assert os.path.exists(pcap_filepath)
    assert os.path.isfile(pcap_filepath)

    start = 0
    results = []
    total_sizes = 0
    with open(pcap_filepath, 'rb') as fp:
        pcap_reader = dpkt.pcap.Reader(fp)

        for ts, buf in pcap_reader:
            if start == 0:
                start = ts

            results.append((ts - start, len(buf)))
            total_sizes += len(buf)

            # eth = dpkt.ethernet.Ethernet(buf)
            # ip = eth.data
            # udp = ip.data
            # results.append((ts - start, len(udp.data)))
            # total_sizes += len(udp.data)

    total_time = results[-1][0]

    throughput = float(total_sizes) * 8 / 1024 / 1024 / total_time
    print('Throughput: %f Mbps' % throughput)
    packet_rate = len(results) / total_time
    print('Packet rate: %f packets / second' % packet_rate)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(1)
    main(sys.argv[1])
    # Alternative approach: capinfos <pcap file>
