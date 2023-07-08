FROM debian:bullseye

RUN apt-get update
RUN apt-get install -yq nginx openssl \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get autoremove

COPY ./tools/script.sh /usr/local/bin/script.sh

COPY ./conf/default /etc/nginx/sites-enabled/default

RUN chmod +x /usr/local/bin/script.sh
WORKDIR /etc/nginx
ENTRYPOINT ["script.sh"]

CMD ["nginx", "-g daemon off;"]