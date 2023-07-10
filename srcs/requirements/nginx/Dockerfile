FROM debian:bullseye

RUN apt-get update -y && apt-get install -y nginx openssl

# Copy the default configuration file to /etc/nginx/conf.d/default
RUN rm /etc/nginx/nginx.conf
COPY ./conf/default /etc/nginx/nginx.conf

COPY ./tools/script.sh /usr/local/bin
RUN chmod +x /usr/local/bin/script.sh

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=PT/ST=Lisbon/O=42Lisboa/OU=student/CN=falmeida.42.fr" \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt

WORKDIR /etc/nginx
ENTRYPOINT [ "/usr/local/bin/script.sh" ]

CMD ["nginx", "-g", "daemon off;"]