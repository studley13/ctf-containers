#!/bin/bash
set -e

if [ $UID -ne 0 ]; then
    echo "Must be run as root"
    exit 1
fi

apt-get install bind9 bind9utils

# Create a zone file
zoneFile="/etc/bind/zone.space.hackingin"
zoneDB="/var/cache/bind/db.space.hackingin"
touch "$zoneDB"
echo "// hackingin.space zone" > "$zoneFile"
echo >> "$zoneFile"

chmod 0640 "$zoneFile" "$zoneDB"
chown root:bind "$zoneFile" "$zoneDB"

# My IP
masterIP=`dig +short myip.opendns.com @resolver1.opendns.com`

# Create the zone db
printf "\
;\n\
; BIND data file for hackingin.space. domain\n\
;\n\
\$TTL	600\n\
@	IN	SOA	hackingin.space. admin.hackingin.space. (\n\
		    `date +"%Y%m%d"`; Serial\n\
			   1200		; Refresh\n\
			    180		; Retry\n\
			    180		; Expire\n\
			    180 )	; Negative Cache TTL\n\
;
@	IN	NS	hackingin.space.\n\
@	IN	A	${masterIP}\n\
master  IN      CNAME   hackingin.space.\n\
scores  IN      CNAME   master.hackingin.space.\n\
" > "$zoneDB"

pushd /home/ctf-admin/dns/
for box in {1..4}; do
  boxname="box${box}.hackingin.space"
  boxfile=`dnssec-keygen -a HMAC-SHA256 -b 256 -r /dev/urandom -n HOST "${boxname}"`
  boxkey=`cat "${boxfile}.private" | awk '{if ($1 == "Key:") {print $2}}'`

#  cat "${boxfile}.key" >> "$zoneDB"
  
  echo "// ${boxname} Key" >> "$zoneFile"
  echo "key ${boxname} {" >> "$zoneFile"
  echo "    algorithm HMAC-SHA256;" >> "$zoneFile"
  echo "    secret \"${boxkey}\";" >> "$zoneFile"
  echo "};" >> "$zoneFile"
  echo >> "$zoneFile"
  echo "$boxname: $boxkey"
done

chown ctf-admin:ctf-admin ./*
popd



# Create the rest of the zone
printf "\n\
zone \"hackingin.space.\" {\n\
    type master;\n\
    notify no;\n\
    file \"${zoneDB}\";\n\
    update-policy {\n\
	grant * self *; \n\
    };\n\
};\n\
" >> "$zoneFile"
#    update-policy {\n" >> "$zoneFile"
#for box in {1..4}; do
#printf "        grant ${boxname} self ${boxname};\n" >> "$zoneFile"
#done
#printf "\n\

# Add zone to bind
echo "include \"${zoneFile}\";" >> "/etc/bind/named.conf"
service bind9 restart

cp ${zoneDB} "/etc/bind/"
