#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-08-17 02:51:30


import os
import sys
import glob

import dpkt
import numpy as np


def process_macsec_handshake_pcap(pcap_filepath):
    assert os.path.exists(pcap_filepath)
    assert os.path.isfile(pcap_filepath)

    start = 0
    ret = []
    cnt = 0
    with open(pcap_filepath, 'rb') as fp:
        pcap_reader = dpkt.pcap.Reader(fp)

        for ts, buf in pcap_reader:
            if start == 0:
                start = ts

            eth = dpkt.ethernet.Ethernet(buf)

            ret.append((ts - start, len(eth.data)))
            cnt += 1

            if cnt >= 14:
                if len(eth.data) >= 134 - 14:
                    break

    key_exchange_time = ret[-1][0]
    total_time = ret[-1][0]
    total_packet_size = sum([pkt[1] for pkt in ret])

    return key_exchange_time, total_time, total_packet_size


def main(data_dir):
    pcap_path_pattern = os.path.join(data_dir, 'macsec_eval_handshake_*.pcap')
    pcap_list = glob.glob(pcap_path_pattern)

    key_exchange_times = []
    total_times = []
    total_packet_sizes = []
    for pcap_filepath in pcap_list:
        data = process_macsec_handshake_pcap(pcap_filepath)
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
    if len(sys.argv) < 2:
        sys.exit(1)
    data_dir = sys.argv[1]
    main(data_dir)
