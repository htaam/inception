#!/bin/bash

sed -i "s/LOGIN/$LOGIN/g" /etc/nginx/sites-enabled/default

mkdir /etc/nginx/certs

# Generate self signed ssl certificate
openssl req -x509 -nodes -days 365 -subj "/C=PT/ST=Lisbon/O=42Lisboa/CN=${LOGIN}.42.fr" \
 -addext "subjectAltName=DNS:${LOGIN}.42.fr" -newkey rsa:2048 -keyout /etc/nginx/certs/${LOGIN}.42.fr.key -out /etc/nginx/certs/${LOGIN}.42.fr.crt

# refer to cheatsheet.txt to know why this is important
exec "$@"