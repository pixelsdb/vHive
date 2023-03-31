#!/bin/bash

# MIT License
#
# Copyright (c) 2020 Dmitrii Ustiugov, Plamen Petrov and EASE lab
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
set -ex

 . /etc/os-release
sudo apt-get update >> /dev/null
sudo apt-get -y install \
    apt-transport-https \
    gcc \
    g++ \
    make \
    acl \
    net-tools \
    git-lfs \
    bc \
    gettext-base \
    jq \
    dmsetup \
    gnupg-agent \
    software-properties-common \
    iproute2 \
    nftables \
    git-lfs >> /dev/null
sudo apt-get -y install curl ca-certificates >> /dev/null
sudo add-apt-repository -y universe >> /dev/null

# stack size, # of open files, # of pids
sudo sh -c "echo \"* soft nofile 1000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"* hard nofile 1000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"root soft nofile 1000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"root hard nofile 1000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"* soft nproc 4000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"* hard nproc 4000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"root soft nproc 4000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"root hard nproc 4000000\" >> /etc/security/limits.conf"
sudo sh -c "echo \"* soft stack 65536\" >> /etc/security/limits.conf"
sudo sh -c "echo \"* hard stack 65536\" >> /etc/security/limits.conf"
sudo sh -c "echo \"root soft stack 65536\" >> /etc/security/limits.conf"
sudo sh -c "echo \"root hard stack 65536\" >> /etc/security/limits.conf"