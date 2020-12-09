#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Date    : 2020-12-08 22:00:00

import os
import sys
import glob
import json

import numpy as np
import matplotlib.pyplot as plt


def plot_throughput(throughput_avgs, throughput_stds):
    width = 0.35

    x = np.arange(100, 1001, 100)
    N = len(x)
    ind = np.arange(N)

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})
    plt.bar(
        ind, throughput_avgs[0], yerr=throughput_stds[0],
        width=width, label='IPsec',
        error_kw=dict(elinewidth=6, ecolor='black'))
    plt.bar(
        ind + width, throughput_avgs[1], yerr=throughput_stds[1],
        width=width, label='MACsec',
        error_kw=dict(elinewidth=6, ecolor='black'))

    for i in range(N):
        plt.text(
            x=ind[i] - 0.08,
            y=throughput_avgs[0][i] + throughput_stds[1][i] + 12,
            s=str(round(throughput_avgs[0][i], 2)), size=18)
        plt.text(
            x=ind[i] + width - 0.08,
            y=throughput_avgs[1][i] + throughput_stds[1][i] + 12,
            s=str(round(throughput_avgs[1][i], 2)), size=18)

    plt.xticks(ind + width / 2, x)
    plt.xlabel('Link Bit Rate (Mbps)')

    plt.ylabel('Throughput (Mbps)')
    plt.ylim(0, 100)

    plt.legend(loc='lower center', ncol=2, bbox_to_anchor=(0.5, 1))
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()
    # plt.margins(x=0, y=0)
    plt.show()
    # plt.savefig('throughput_figure.png')


def process_result_files(data_dir_path, topic):
    assert os.path.exists(data_dir_path)

    throughput_avgs = []
    throughput_stds = []
    for bit_rate in range(100, 1001, 100):
        result_path_pattern = os.path.join(
            data_dir_path, '%s_client_%dMbit_*.log' % (topic, bit_rate))
        result_list = glob.glob(result_path_pattern)

        throughputs = []
        for result_path in result_list:
            with open(result_path, 'r') as fp:
                result_json = json.load(fp)
            throughput = result_json['end']['sum_sent']['bits_per_second']
            throughputs.append(throughput)

        # avg & std dev
        throughput_avgs.append(np.mean(throughputs) / 1000 / 1000)  # to Mbps
        throughput_stds.append(np.std(throughputs) / 1000 / 1000)  # to Mbps

    return throughput_avgs, throughput_stds


def main(data_dir):
    # Load meta.json
    meta_json_path = os.path.join(data_dir, 'meta.json')
    with open(meta_json_path, 'r') as fp:
        meta_json = json.load(fp)
        ipsec_dir = meta_json.get('ipsec')
        macsec_dir = meta_json.get('macsec')

    if ipsec_dir is None or macsec_dir is None:
        print('No data!')
        return

    # IPsec
    ipsec_dir_path = os.path.join(data_dir, ipsec_dir)
    ipsec_throughput_avgs, ipsec_throughput_stds = process_result_files(
        ipsec_dir_path, 'ipsec_eval')

    # MACsec
    macsec_dir_path = os.path.join(data_dir, macsec_dir)
    macsec_throughput_avgs, macsec_throughput_stds = process_result_files(
        macsec_dir_path, 'macsec_eval')

    # Plot throughput figure
    throughput_avgs = [ipsec_throughput_avgs, macsec_throughput_avgs]
    throughput_stds = [ipsec_throughput_stds, macsec_throughput_stds]
    print(throughput_avgs)
    plot_throughput(throughput_avgs, throughput_stds)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Insufficient arguments!')
        sys.exit(1)
    data_dir = sys.argv[1]
    main(data_dir)
