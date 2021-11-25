#!/bin/bash

ssh-keygen -b 2048 -t rsa -f /home/ec2-user/sshkey -q -N ""
chmod 600 /home/ec2-user/shhkey
cat /home/ec2-user/sshkey.pub >> /root/.ssh/authorized_keys

