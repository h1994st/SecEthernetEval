#!/bin/bash

DATA_FILENAME=$1

perf script -i $DATA_FILENAME.data | ~/Developer/Project/FlameGraph/stackcollapse-perf.pl --all | ~/Developer/Project/FlameGraph/flamegraph.pl > $DATA_FILENAME.svg
