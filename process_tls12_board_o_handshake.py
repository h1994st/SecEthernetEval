#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2020-08-17 01:03:24

import os
import sys
import glob

import dpkt
import numpy as np


def process_tls12_ecc_handshake_pcap(pcap_filepath):
    assert os.path.exists(pcap_filepath)
    assert os.path.isfile(pcap_filepath)

    start = 0
    ret = []
    cnt = 0
    print(pcap_filepath)
    with open(pcap_filepath, 'rb') as fp:
        pcap_reader = dpkt.pcap.Reader(fp)

        for ts, buf in pcap_reader:
            if start == 0:
                start = ts

            eth = dpkt.ethernet.Ethernet(buf)
            ip = eth.data
            tcp = ip.data

            if (len(tcp.data) == 0):
                continue

            ret.append((ts - start, len(tcp.data)))
            cnt += 1

            if cnt >= 4:
                break

    key_exchange_time = ret[2][0]
    total_time = ret[3][0]
    total_packet_size = ret[0][1] + ret[1][1] + ret[2][1] + ret[3][1]

    return key_exchange_time, total_time, total_packet_size


def main(data_dir, o_level):
    pcap_path_pattern = os.path.join(data_dir, 'tls12_board_o%d_ecc_handshake_*.pcap' % o_level)
    pcap_list = glob.glob(pcap_path_pattern)

    if len(pcap_list) == 0:
        print("No existing pcap files!")
        return

    key_exchange_times = []
    total_times = []
    total_packet_sizes = []
    for pcap_filepath in pcap_list:
        data = process_tls12_ecc_handshake_pcap(pcap_filepath)
        key_exchange_times.append(data[0])
        total_times.append(data[1])
        total_packet_sizes.append(data[2])

    print('Key exchange time: %f (avg), %f (std dev)' % (
        np.mean(key_exchange_times), np.std(key_exchange_times)))
    print('Total time: %f (avg), %f (std dev)' % (
        np.mean(total_times), np.std(total_times)))
    print('Total packet size: %f (avg), %f (std dev)' % (
        np.mean(total_packet_sizes), np.std(total_packet_sizes)))


if __name__ == '__main__':
    if len(sys.argv) < 3:
        sys.exit(1)
    data_dir = sys.argv[1]
    o_level = int(sys.argv[2])
    main(data_dir, o_level)
