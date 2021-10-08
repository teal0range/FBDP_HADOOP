#! /bin/bash

echo "source /etc/profile" >> ~/.bashrc
cat /root/profile >> /etc/profile
cat /root/hosts > /etc/hosts
cp /root/config /root/.ssh/config
service ssh start