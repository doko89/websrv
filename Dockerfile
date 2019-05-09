FROM alpine:latest

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community gnu-libiconv

RUN apk add --no-cache composer nginx supervisor curl \
    php7 php7-fpm php7-gd php7-intl php7-pdo php7-opcache php7-xmlrpc php7-xmlwriter php7-tokenizer php7-fileinfo \
    php7-exif php7-bcmath php7-zip php7-xsl php7-xml php7-soap php7-mbstring php7-simplexml php7-redis \
    php7-pdo_mysql php7-pdo_pgsql php7-pdo_sqlite php7-fileinfo php7-ctype php7-memcached php7-curl \
    php7-json php7-session  && rm -rf /var/cache/apk/* && \
    rm -rf /etc/nginx/conf.d/default.conf && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php7/php-fpm.conf && \
    sed -i '/client_max_body_size/d' /etc/nginx/nginx.conf && \
    sed -i 's/user nginx/user xfs/' /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir /run/nginx && \
    chown -R xfs /var/tmp/nginx && \
    sed -i 's+nobody+xfs+g;s+;listen.group+listen.group+;s+;listen.owner+listen.owner+;s+127.0.0.1:9000+/run/php7.2-fpm.sock+' /etc/php7/php-fpm.d/www.conf

COPY config/supervisor /etc/supervisor.d

COPY config/nginx/redirect_param /etc/nginx/redirect_param

COPY config/nginx/extra_param /etc/nginx/extra_param

COPY config/nginx/gzip_param /etc/nginx/gzip_param

COPY config/nginx/php_param /etc/nginx/php_param

COPY config/nginx/ssl_param /etc/nginx/ssl_param

COPY config/nginx/conf /conf

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

COPY run.sh /run.sh

WORKDIR /app

EXPOSE 443 80

CMD ["/run.sh"]

