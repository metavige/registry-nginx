#!/bin/sh

if [ ! -e "/etc/nginx/ssl/nginx.cert" ] || [ ! -e "/etc/nginx/ssl/nginx.key" ]
then
    mkdir -p /etc/nginx/ssl

    openssl req -x509 -newkey rsa:4086 \
      -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=registry.co" \
      -keyout "/etc/nginx/ssl/nginx.key" \
      -out "/etc/nginx/ssl/nginx.cert" \
      -days 3650 -nodes -sha256
fi

nginx
