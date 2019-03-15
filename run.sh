#!/bin/sh

cp /conf/$ENV.conf /etc/nginx/conf.d/app.conf

if [ ! "$SSL" == "on" ];then sed -i '/ssl_param/d;s/443/80/' /etc/nginx/conf.d/app.conf; fi
if [ "$SSL" == "on" ];then sed -i "s/CERT/$SSL_CERT/;s/KEY/$SSL_KEY" /etc/nginx/ssl_param; fi

sed -i "s+DOMAIN+$DOMAIN+g"	/etc/nginx/conf.d/app.conf
sed -i "s+WEBPATH+$WEBPATH+g"	/etc/nginx/conf.d/app.conf

if [ -f /app/pre.sh ]; then
	sh /app/pre.sh
fi

if [ -f /app/php.ini ]; then
	cat /app/php.ini > /etc/php7/php.ini
fi
if [ -f /app/www.conf ]; then
	cat /app/www.conf > /etc/php7/php-fpm.d/www.conf
fi


/usr/bin/supervisord

