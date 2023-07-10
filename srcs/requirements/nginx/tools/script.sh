#!/bin/bash

ln -s /etc/nginx/ssl/nginx.crt /etc/ssl/certs/nginx.crt
ln -s /etc/nginx/ssl/nginx.key /etc/ssl/private/nginx.key

exec "$@"