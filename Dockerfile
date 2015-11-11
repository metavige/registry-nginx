FROM alpine:3.2
MAINTAINER Ricky Chiang<metavige@gmail.com>

ENV NGINX_VERSION nginx-1.9.6

RUN echo " =====> Install Packages" && \
    apk -U add openssl-dev pcre-dev apache2-utils wget build-base && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    echo " =====> Download Nginx and build..... " && \
    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxvf ${NGINX_VERSION}.tar.gz && \
    cd /tmp/src/${NGINX_VERSION} && \
    echo " =====> Confiugre....." && \
    ./configure \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/var/run/nginx.pid \
        --with-http_auth_request_module && \
    echo " =====> Make and Install....." && \
    make && \
    make install && \
    echo " =====> Cleanup....." && \
    apk del build-base wget && \
    rm -Rf /tmp/src && \
    rm -Rf /var/cache/apk/* && \
	rm -rf /etc/nginx/conf.d/* && \
	mkdir -p /etc/nginx/external

COPY . /

EXPOSE 80

CMD ["nginx"]
