#!/bin/bash
set -e

if [ $UID -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

# Install required packages
apt-get update
apt-get install -y docker docker.io gcc make

# Enable RSA authentication
# echo "IdentityFile %h/.ssh/id_rsa" >> /etc/ssh/sshd_config
echo >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile	%h/.ssh/authorized_keys" >> /etc/ssh/sshd_config

# Create a docker user
mkdir -p /home/ctf
mkdir -p /home/ctf/static
mkdir -p /home/ctf/.ssh
chmod -R 775 /home/ctf
chmod 700 /home/ctf/.ssh
cp ctf-test-public.pem /home/ctf/.ssh/id_rsa
cat /home/ctf/.ssh/id_rsa >> /home/ctf/.ssh/authorized_keys
chmod 600 /home/ctf/.ssh/id_rsa
chmod 600 /home/ctf/.ssh/authorized_keys
 
useradd -M -U -s /bin/bash -G docker -d /home/ctf ctf

chown -R ctf:ctf /home/ctf
