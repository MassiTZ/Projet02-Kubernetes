#!/bin/bash

IP=$(hostname -I | awk '{print $2}')

sed -e "s/^.*${HOSTNAME}.*/${IP} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

cat >> /etc/hosts <<EOF
192.168.56.10 master01
192.168.56.11 node01
192.168.56.12 node02
EOF

