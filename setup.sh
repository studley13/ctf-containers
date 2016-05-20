#!/bin/bash
set -e

if [ $UID -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

# Install required packages
apt-get update
apt-get install -y docker docker.io gcc make
docker.io

# Create the base static container
docker build -t ctf-static-base web-base

# Create the base network container
pushd net-base
make
popd
docker build -t ctf-net-base net-base

# Create the base web container
docker build -t ctf-web-base web-base

# Create a docker user
mkdir -p /home/ctf
mkdir -p /home/ctf/static
mkdir -p /home/ctf/.ssh
chmod -R 775 /home/ctf
cp ctf-public.pem /home/ctf/.ssh/id_rsa
chmod 600 /home/ctf/.ssh/id_rsa
 
useradd -M -U -s /bin/bash -G docker -d /home/ctf ctf

chown -R ctf:ctf /home/ctf
