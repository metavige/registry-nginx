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
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_auth_request_module && \
    echo " =====> Make and Install....." && \
    make && \
    make install && \
    echo " =====> Cleanup....." && \
    apk del build-base wget && \
    rm -Rf /tmp/src && \
    rm -Rf /var/cache/apk/* && \
	rm -rf /etc/nginx/conf.d/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 443

CMD ["/entrypoint.sh"]
