#!/bin/bash
set -e

if [ $UID -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

# Get the hostname
printf "Enter hostname:"
read hostname

# set the hostname
hostnamectl set-hostname $hostname

# Install required packages
apt-get update
apt-get install -y docker docker.io

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
touch /home/ctf/.ssh/authorized_keys
chmod 600 /home/ctf/.ssh/authorized_keys
useradd -M -U -s /bin/bash -G docker -d /home/ctf ctf
chown -R ctf:ctf /home/ctf

# Create an admin user
useradd -p -m -U -s /bin/bash -G docker,sudo,adm,admin,ctf ctf-admin
mkdir -p /home/ctf-admin/.ssh
chmod 0700 /home/ctf-admin/.ssh
touch /home/ctf-admin/.ssh/authorized_keys
echo "\
c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUdXUEprZFRJdmQ0Q3lnM3c0em5v\
RmVyZjVoU3U3WE9EQ2JlZE5jeERPL1Igc2VhbkBzLmxvY2FsCnNzaC1yc2EgQUFBQUIzTnphQzF5\
YzJFQUFBQURBUUFCQUFBQkFRREhSSUM5Ymw1SDcxb01oV1lUV2VUTG9ZVVZscWQ3Q2ZtVStYWWFk\
anRmc3ROcXJEeE1QMzlOUGU0VHdoWnZ5NHYzZ0p4cHFxSG4veFlYVUVsNmZTQVNBYzdwY2RraHgx\
anM5TkFzRVNyT0RSMFIwM05pTk5RTUhSbVFPcFVJUTVlOGNCeFZaOXZ3YzdnMmwzeE9vWFhZOWRU\
MWlwVTNpcVl4QlhhdHRWZ0dsNUFTK3RxU1YzeDJJN2N5dVRFQ2lxMmhyd0dDdnlCRHFqVWd0V1lt\
clFlRlN4dlFzU2FwTEhlbFRaN09UL0tOdmVEdGJES3I0MnZoSTVyZU1WTDBPWEQ5elJueFZ3MklQ\
RVNHbDVBY0lIRXVZUEhsdnMzNGNGOS9UdzJrMzBsMjFWc0FvUzQ2WFNnSzJvdytSU3lmWUg5V0xY\
TjZid1Y5dk11TTcva053dEs1IGFuZHJld0BldnZ5CnNzaC1yc2EgQUFBQUIzTnphQzF5YzJFQUFB\
QUJJd0FBQVFFQXhaN01iekh3ZGZhTWZxMENuYk9Ld2pOazRIWXA1K2RRMnNraFVEaEVhRG9RRHNC\
UWFqbm5BdTFJK3RORVpBWWYxU2NBTHVHNVJQNWlXTjZ6NDBHVGM4d3JSTG0xUGZQNzFDVUpWVHZV\
eEpVR0ZjeHg1aWZDU0NOMUttMmlsZ05sTWxKNkRpcHBQbHhNQUN1U2pocDJGempmSXhCcGxzOXRE\
b3hZZWhIZk0vNDFKU2FESTNNYU5tNC9YU1k1VFFxazlqVDJkOVRFWGVRTGFlZFA3dEN1QXBYNTRw\
Sy9LQTZtYkJxcXZEQVQrU0JPZ00yRnFvY3lKQ0IvZkRBRW9qd05ZVXlEa29LaDFHeWMyZEtlUmsy\
dXFsUlRlL3ZYeUdNVXptdEJDS0RDT2c5ZnIwa3V6YXQzcVpBTlVuTWg5SnhuU2FYSGsycU9rNGxO\
Q3dWYkE1cnNpdz09IGFuZHJld2JAd2FnbmVyCnNzaC1yc2EgQUFBQUIzTnphQzF5YzJFQUFBQURB\
UUFCQUFBQkFRRFRvdXlBV0x6dS9lZklBZkRpTEhIZWY4eWE0N2FkOWZaQzBtNzNjZXNpYklTZThJ\
b29VSHhWL2piYVVBMDRsRGNManNaZUJKZ2FRTUV0SUlDb0p1T0IrZjI5bnlrQ0M4Y0ZVVThEK2Nn\
QzFrNk9IVjVhdEF5R003Q0hCb1dxM2hVWW9xK0RheVBIZjhUVHFkYnFKOEUrMWU1TklNZ3kvMER2\
d2pQaXNrd2hjNGFWelBkRVJWSjBEYlR3d2E0b1hBRWRRazVPbmxwd014OG5iWXJiQ1JrMUJxelR2\
WERxdEVYWlZOMTduaXNYUEhILzNzcWRCd2hZV3g2SUcwcXVBaWpVMGtlaCt2M2FUUmN0Z1JYaG9V\
Q3hldzJjeGFkQmRNaisyMzBjLzgvdWMxM3l4V3dMSER0RHg2SGhGNEdvSVkxTmxHb2VOeHdKYVFI\
cEtGa0VadCtQIGN1cnRpc0BjdXJ0aXMtbGFwdG9wCnNzaC1yc2EgQUFBQUIzTnphQzF5YzJFQUFB\
QURBUUFCQUFBQkFRQzBFbjA2TXRFRmpYMUtuVFh3Y2tZcFFJRURLTDRNRWFBN0pLdG43TzAzMU9u\
ajlpUzZZZnF3dWJ0TUhpZVZZL1FoZ2FTZGIzWTJXOWRHUnZMTURnMmo4anNwcElKQVFHbWk3VEwr\
WlNScGgvN1dHL05taUt2RVN6dS94djZOcmQxY1NtSENOcXcwdEVacDRDSUZIRUcxV2xhZUxPVnBQ\
dGlmL3hPcG9tNlpkM3BPSkQ4RDdDekRFY0lBRnNaWEZuRDdFRDQ3c0ovTDBWR1VFbkJlY0UyeU13\
aGo3VGFlZU1JN0ljb1BoSHk0bjlBU0liOE5lUEdVNnpEVjlJL3ArRHVSQTlsbDRNOURsdGRUVGVO\
TE1ybHlFSkdPY1BmTzFDV0g5YVh0eDN6WUtwaHlhTVJJVWZ0MHRXSVpCTys2S1lhWHJ1aVE2a3lz\
Tk1kMDMxVmxVa0JYIGRhbmllbEBjYWFuCnNzaC1yc2EgQUFBQUIzTnphQzF5YzJFQUFBQURBUUFC\
QUFBQkFRREROYzl3Um5yU2hDa2ZKbWlYMEdzRG1QanF5OWgzcGRoSnZmVlByYlUwOVpFMjU2aUta\
NUlON3FaY2ZXZURmWTgycXpDVGkvS2ZOa3NNdWZMS1psdSs4SGtic3BlMi80K0lIZ0UxY0xyMElG\
YjVUWUlWL001eFN6QUp2eHlINVVuTlNrcjhoMnVrNk9WUVJaWjEvaDAwYVFaTHVkSFBXdVZhalRt\
S1JZeVJlL1MrYis5Q0N4Y3lOWEtYVzdSTFNRZDFqN0dQNGZ1NU10OThaTldYNFRRelc0WXBmQTFF\
SHV4MW83YnBSeU5UUEdVV1gyUDlhOFdFNXNRd1JtZDRmU3lCRXFpOHBqLzgxTXVNUTk5WEFSN1E1\
d1JBYThYT3d2TFhySUhTR2RnSkxSeUVNUTRrVkRBbklyTGRUb1FjK0laeEQ1UGFuazhRSkdkYU94\
M0VBZjVEIGhqZWRASEpFRC1QQw==" | base64 -d > /home/ctf-admin/.ssh/authorized_keys
chmod 0600 /home/ctf-admin/.ssh/authorized_keys
chown -R ctf-admin:ctf-admin /home/ctf-admin

# Add sudoers exception
echo "ctf-admin ALL=NOPASSWD: ALL" > /etc/sudoers.d/ctf-admin
chmod 0440 /etc/sudoers.d/ctf-admin

# Create a DNS Update key
mkdir -p /home/ctf-admin/dns
chmod 700 /home/ctf-admin/dns
printf "\
IyEvYmluL2Jhc2gKCiMgVXBkYXRlIHRoZSBuYW1lIHJlY29yZCBmb3IgdGhpcyBjb21wdXRlcgoK\
bmFtZT1gaG9zdG5hbWVgCmRvbWFpbj1gaG9zdG5hbWUgLWRgCmFkZHI9YGRpZyArc2hvcnQgbXlp\
cC5vcGVuZG5zLmNvbSBAcmVzb2x2ZXIxLm9wZW5kbnMuY29tYApzZXJ2ZXI9Im1hc3Rlci5oYWNr\
aW5naW4uc3BhY2UiCmtleWRpcj0iL2hvbWUvY3RmLWFkbWluL2RucyIKa2V5PWBscyAke2tleWRp\
cn0gfCBncmVwICoua2V5IHwgc2VkICJzL1woLipcKVwua2V5L1wxLyJgCgpwcmludGYgIlxuXApz\
ZXJ2ZXIgJHtzZXJ2ZXJ9XG5cCnpvbmUgJHtkb21haW59XG5cCnl4ZG9tYWluICR7bmFtZX1cblwK\
dXBkYXRlIGRlbCAke25hbWV9XG5cCnNlbmRcblwKc2VydmVyICR7c2VydmVyfVxuXAp6b25lICR7\
ZG9tYWlufVxuXAp1cGRhdGUgYWRkICR7bmFtZX0gNjAwIEEgJHthZGRyfVxuXApzZW5kXG5cCiIg\
fCBuc3VwZGF0ZSAtayAke2tleWRpcn0vJHtrZXl9IDI+IC9kZXYvbnVsbCA+IC9kZXYvbnVsbAoK"\
    | base64 -d > /home/ctf-admin/dns/update
chmod 770 /home/ctf-admin/dns/update
chown -R ctf-admin:ctf-admin /home/ctf-admin

# Add cron job
randomTime=`expr $RANDOM % 60`
echo "$randomTime * * * * ctf-admin /home/ctf-admin/dns/update" >> /etc/crontab

