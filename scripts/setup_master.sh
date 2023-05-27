#!/bin/bash
set -x

MODE=$1
if [ -z "$MODE" ]; then
    MODE="multinode"
fi
if [ "$MODE" != "multinode" ] && [ "$SANDBOX" != "onenode" ]; then
    echo Specified mode is not supported. Possible are \"multinode\" and \"onenode\"
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

mkdir -p /tmp/vhive-logs
sudo screen -dmS containerd bash -c "containerd > >(tee -a /tmp/vhive-logs/containerd.stdout) 2> >(tee -a /tmp/vhive-logs/containerd.stderr >&2)"
if [ "$MODE" == "multinode" ]; then
    $SCRIPTS/cluster/create_multinode_cluster.sh > >(tee -a /tmp/vhive-logs/create_multinode_cluster.stdout) 2> >(tee -a /tmp/vhive-logs/create_multinode_cluster.stderr >&2)
fi
if [ "$MODE" == "onenode" ]; then
    $SCRIPTS/cluster/create_one_node_cluster.sh > >(tee -a /tmp/vhive-logs/create_one_node_cluster.stdout) 2> >(tee -a /tmp/vhive-logs/create_one_node_cluster.stderr >&2)
fi