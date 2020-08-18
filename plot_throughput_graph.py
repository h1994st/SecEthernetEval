#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2020-08-17 13:59:27

import numpy as np
import matplotlib.pyplot as plt


def main():
    N = 3
    width = 0.35

    throughput_avgs = [[91.1904, 93.425, 93.49],
                       [916.8604, 853.1, 647.9]]
    throughput_stds = [[0.0145905521, 0.04442616583, 0.03077935056],
                       [0.6565464989, 8.540306909, 18.18009322]]

    x = ['TLS 1.3', 'IPsec', 'MACsec']
    ind = np.arange(N)

    plt.figure(figsize=(13, 7))
    plt.rcParams.update({'font.size': 24})
    plt.bar(
        ind, throughput_avgs[0], yerr=throughput_stds[0],
        width=width, label='100 Mbps Link',
        error_kw=dict(elinewidth=6, ecolor='black'))
    plt.bar(
        ind + width, throughput_avgs[1], yerr=throughput_stds[1],
        width=width, label='1 Gbps Link',
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
    plt.xlabel('Protocols')

    plt.ylabel('Throughput (Mbps)')
    plt.ylim(0, 1000)

    plt.legend(loc='lower center', ncol=2, bbox_to_anchor=(0.5, 1))
    plt.grid(True, axis='y', linestyle='--')
    plt.tight_layout()
    # plt.margins(x=0, y=0)
    # plt.show()
    plt.savefig('throughput_figure.png')


if __name__ == '__main__':
    main()
