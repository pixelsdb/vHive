#!/bin/bash

sudo sysctl --quiet -w net.ipv4.conf.all.forwarding=1
# Avoid "neighbour: arp_cache: neighbor table overflow!"
sudo sysctl --quiet -w net.ipv4.neigh.default.gc_thresh1=1024
sudo sysctl --quiet -w net.ipv4.neigh.default.gc_thresh2=2048
sudo sysctl --quiet -w net.ipv4.neigh.default.gc_thresh3=4096
sudo sysctl --quiet -w net.ipv4.ip_local_port_range="32769 65535"
sudo sysctl --quiet -w kernel.pid_max=4194303
sudo sysctl --quiet -w kernel.threads-max=999999999
sudo swapoff -a >> /dev/null
sudo sysctl --quiet net.ipv4.ip_forward=1
sudo sysctl --quiet -w net.ipv4.conf.all.promote_secondaries=1
sudo sysctl --quiet --system

# NAT setup
hostiface=$(sudo route | grep default | tr -s ' ' | cut -d ' ' -f 8)
sudo nft "add table ip filter"
sudo nft "add chain ip filter FORWARD { type filter hook forward priority 0; policy accept; }"
sudo nft "add rule ip filter FORWARD ct state related,established counter accept"
sudo nft "add table ip nat"
sudo nft "add chain ip nat POSTROUTING { type nat hook postrouting priority 0; policy accept; }"
for eth in ${hostiface}
do
sudo nft "add rule ip nat POSTROUTING oifname ${eth} counter masquerade"
done

# Necessary for containerd as container runtime but not docker
sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
sudo tee /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --quiet --system