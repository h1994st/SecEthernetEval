#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2020-12-08 22:00:00

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_throughput(throughput_avgs, throughput_stds, labels,
                    data_label=False):
    width = 0.25

    x = np.arange(100, 1001, 100)
    if len(throughput_avgs[0]) == len(x) + 1:
        x = list(x) + [-1]
    N = len(x)
    ind = np.arange(N)
    M = len(labels)

    y_max = 0
    for i in range(M):
        y_max = max(y_max, max(throughput_avgs[i]))
    y_max += 20

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})
    for i in range(M):
        plt.bar(
            ind + i * width, throughput_avgs[i], yerr=throughput_stds[i],
            width=width, label=labels[i],
            error_kw=dict(elinewidth=6, ecolor='black'))

    # Data label
    if data_label:
        for i in range(N):
            for j in range(M):
                plt.text(
                    x=ind[i],
                    y=throughput_avgs[j][i] + throughput_stds[j][i] + 12,
                    s=str(round(throughput_avgs[j][i], 2)), size=18)

    plt.xticks(ind - width / 2 + width * M / 2, x)
    plt.xlabel('Link Bit Rate (Mbps)')

    plt.ylabel('Throughput (Mbps)')
    plt.ylim(0, y_max)

    plt.legend(loc='lower center', ncol=M, bbox_to_anchor=(0.5, 1))
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()
    # plt.margins(x=0, y=0)
    plt.show()
    # plt.savefig('throughput_figure.png')


def extract_throughput_from_json(result_path):
    with open(result_path, 'r') as fp:
        result_json = json.load(fp)
    throughput = result_json['end']['sum_sent']['bits_per_second']
    return throughput


def process_result_json_files(data_dir_path, topic, w_unlimited=False):
    throughput_avgs = []
    throughput_stds = []
    for bit_rate in range(100, 1001, 100):
        result_path_pattern = os.path.join(
            data_dir_path, '%s_client_%dMbit_*.log' % (topic, bit_rate))
        result_list = glob.glob(result_path_pattern)

        throughputs = []
        for result_path in result_list:
            throughput = extract_throughput_from_json(result_path)
            throughputs.append(throughput)

        # avg & std dev
        throughput_avgs.append(np.mean(throughputs) / 1000 / 1000)  # to Mbps
        throughput_stds.append(np.std(throughputs) / 1000 / 1000)  # to Mbps

    if w_unlimited:
        # unlimited
        result_path_pattern = os.path.join(
            data_dir_path, '%s_client_unlimited_*.log' % (topic, bit_rate))
        result_list = glob.glob(result_path_pattern)

        throughputs = []
        for result_path in result_list:
            throughput = extract_throughput_from_json(result_path)
            throughputs.append(throughput)

        # avg & std dev
        throughput_avgs.append(np.mean(throughputs) / 1000 / 1000)  # to Mbps
        throughput_stds.append(np.std(throughputs) / 1000 / 1000)  # to Mbps

    return throughput_avgs, throughput_stds


def extract_throughput_from_text(result_path):
    with open(result_path, 'r') as fp:
        for line in fp:
            if line.find('sender') != -1:
                end_pos = line.find('bits/sec')
                start_pos = line.find('Bytes') + 5
                throughput = int(line[start_pos:end_pos])
                return throughput
    return None


def process_result_text_files(data_dir_path, topic, w_unlimited=False):
    throughput_avgs = []
    throughput_stds = []

    # 100 Mbps to 1000 Mbps
    for bit_rate in range(100, 1001, 100):
        result_path_pattern = os.path.join(
            data_dir_path, '%s_client_%dMbit_*.log' % (topic, bit_rate))
        result_list = glob.glob(result_path_pattern)

        throughputs = []
        for result_path in result_list:
            throughput = extract_throughput_from_text(result_path)
            throughputs.append(throughput)

        # avg & std dev
        throughput_avgs.append(np.mean(throughputs) / 1000 / 1000)  # to Mbps
        throughput_stds.append(np.std(throughputs) / 1000 / 1000)  # to Mbps

    if w_unlimited:
        # unlimited
        result_path_pattern = os.path.join(
            data_dir_path, '%s_client_unlimited_*.log' % (topic))
        result_list = glob.glob(result_path_pattern)

        throughputs = []
        for result_path in result_list:
            throughput = extract_throughput_from_text(result_path)

            # # !!! Temp: replace all numbers with 0, when the topic is 'none_eval'
            # if topic == 'none_eval':
            #     throughput = 0

            throughputs.append(throughput)

        # avg & std dev
        throughput_avgs.append(np.mean(throughputs) / 1000 / 1000)  # to Mbps
        throughput_stds.append(np.std(throughputs) / 1000 / 1000)  # to Mbps

    return throughput_avgs, throughput_stds


def process_result_files(data_dir_path, topic, result_type, w_unlimited=False):
    assert os.path.exists(data_dir_path)
    if result_type == 'json':
        return process_result_json_files(data_dir_path, topic, w_unlimited)
    if result_type == 'text':
        return process_result_text_files(data_dir_path, topic, w_unlimited)
    return 0, 0


def main(data_dir):
    # Load meta.json
    meta_json_path = os.path.join(data_dir, 'meta.json')
    with open(meta_json_path, 'r') as fp:
        meta_json = json.load(fp)
        ipsec_entry = meta_json.get('ipsec')
        macsec_entry = meta_json.get('macsec')
        none_entry = meta_json.get('none')

        ipsec_dir = ipsec_entry.get('dir')
        ipsec_type = ipsec_entry.get('type')
        macsec_dir = macsec_entry.get('dir')
        macsec_type = macsec_entry.get('type')
        none_dir = none_entry.get('dir')
        none_type = none_entry.get('type')

    if ipsec_dir is None:
        print('No IPsec data!')
        return
    if macsec_dir is None:
        print('No MACsec data!')
        return
    if none_dir is None:
        print('No baseline data!')
        return

    w_unlimited = False
    # IPsec
    ipsec_dir_path = os.path.join(data_dir, ipsec_dir)
    ipsec_throughput_avgs, ipsec_throughput_stds = process_result_files(
        ipsec_dir_path, 'ipsec_eval', ipsec_type, w_unlimited)
    print('IPsec:')
    print(ipsec_throughput_avgs)
    print(ipsec_throughput_stds)

    # MACsec
    macsec_dir_path = os.path.join(data_dir, macsec_dir)
    macsec_throughput_avgs, macsec_throughput_stds = process_result_files(
        macsec_dir_path, 'macsec_eval', macsec_type, w_unlimited)
    print('MACsec:')
    print(macsec_throughput_avgs)
    print(macsec_throughput_stds)

    # No security protocols
    none_dir_path = os.path.join(data_dir, none_dir)
    none_throughput_avgs, none_throughput_stds = process_result_files(
        none_dir_path, 'none_eval', none_type, w_unlimited)
    print('Baseline:')
    print(none_throughput_avgs)
    print(none_throughput_stds)

    # Plot throughput figure
    throughput_avgs = [
        ipsec_throughput_avgs,
        macsec_throughput_avgs,
        none_throughput_avgs
    ]
    throughput_stds = [
        ipsec_throughput_stds,
        macsec_throughput_stds,
        none_throughput_stds
    ]
    labels = [
        'IPsec', 'MACsec',
        'Baseline'
    ]
    plot_throughput(throughput_avgs, throughput_stds, labels)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Insufficient arguments!')
        sys.exit(1)
    data_dir = sys.argv[1]
    main(data_dir)
