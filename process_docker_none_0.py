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
    width = 0.5

    x = np.arange(1, 16, 1)
    if len(throughput_avgs) == len(x) + 1:
        x = list(x) + [-1]
    N = len(x)
    ind = np.arange(N)

    y_max = max(throughput_avgs)
    y_max += 20

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 20})
    plt.bar(
        ind, throughput_avgs, yerr=throughput_stds,
        width=width, label=labels[0], color='green',
        error_kw=dict(elinewidth=6, ecolor='black'))

    # Data label
    if data_label:
        for i in range(N):
            plt.text(
                x=ind[i],
                y=throughput_avgs[i] + throughput_stds[i] + 12,
                s=str(round(throughput_avgs[i], 2)), size=18)

    plt.xticks(ind, x)
    plt.xlabel('Link Bit Rate (Gbps)')

    plt.ylabel('Throughput (Mbps)')
    plt.ylim(0, y_max)

    plt.legend(loc='lower center', ncol=1, bbox_to_anchor=(0.5, 1))
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()
    # plt.margins(x=0, y=0)
    plt.show()
    # plt.savefig('throughput_figure.png')


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

    # 1 Gbps to 30 Gbps
    for bit_rate in range(1, 16, 1):
        result_path_pattern = os.path.join(
            data_dir_path, '%s_client_%dGbit_*.log' % (topic, bit_rate))
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

            throughputs.append(throughput)

        # avg & std dev
        throughput_avgs.append(np.mean(throughputs) / 1000 / 1000)  # to Mbps
        throughput_stds.append(np.std(throughputs) / 1000 / 1000)  # to Mbps

    return throughput_avgs, throughput_stds


def process_result_files(data_dir_path, topic, result_type, w_unlimited=False):
    assert os.path.exists(data_dir_path)
    return process_result_text_files(data_dir_path, topic, w_unlimited)


def main(none_dir_path):
    w_unlimited = False

    # No security protocols
    none_throughput_avgs, none_throughput_stds = process_result_files(
        none_dir_path, 'none_eval', 'text', w_unlimited)
    print('Baseline:')
    print(none_throughput_avgs)
    print(none_throughput_stds)

    # Plot throughput figure
    labels = [
        'Baseline'
    ]
    plot_throughput(none_throughput_avgs, none_throughput_stds, labels)


if __name__ == '__main__':
    cur_dir = os.path.dirname(sys.argv[0])
    data_dir = os.path.join(cur_dir, 'results/ecu_containers/none_0')
    main(data_dir)
