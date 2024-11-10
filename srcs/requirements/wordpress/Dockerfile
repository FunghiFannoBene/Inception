FROM debian:bullseye

RUN apt update && apt install -y \
		ghostscript \
                php \
                php-bcmath \
                php-curl \
                php-imagick \
                php-intl \
                php-json \
                php-mbstring \
                php-mysql \
                php-xml \
                php-zip \
		curl \
		php-fpm \
		default-mysql-client

RUN mkdir -p /srv/www && chown www-data:www-data /srv/www && curl -o wordpress.tar.gz -SL https://wordpress.org/latest.tar.gz && \
tar -xzf wordpress.tar.gz -C /srv/www/ --strip-components=1 && chown -R www-data:www-data /srv/www && rm wordpress.tar.gz

RUN sed -i 's/listen = \/run\/php\/php.*.fpm.sock/listen = 9000/' /etc/php/*/fpm/pool.d/www.conf

RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY ./conf/wp-config.php /srv/www/

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
