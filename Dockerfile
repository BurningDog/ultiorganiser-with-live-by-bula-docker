FROM php:7.4-apache

RUN apt-get update --assume-yes \
 && apt-get install --assume-yes zlib1g-dev libpng-dev libonig-dev gettext locales \
 && locale-gen en_GB.UTF-8 fi_FI.UTF-8 \
 && docker-php-ext-install mysqli gettext gd mbstring \
 && a2enmod rewrite \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Allow .htaccess overrides for the document root
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' \
    /etc/apache2/apache2.conf

# We won't need the install file because we import the database file ourselves:
RUN rm -f uo-with-live-1.9.16/install.php
# Copy the entire folder
COPY uo-with-live-1.9.16/ /var/www/html/
# Config uses environment variables set in .env
COPY conf/config.inc.php /var/www/html/conf/

# Create upload directory (not present in source) and fix permissions
# on all directories that the app needs to write to at runtime
RUN mkdir -p /var/www/html/images/uploads \
 && chown -R www-data:www-data \
      /var/www/html/conf \
      /var/www/html/images/uploads \
      /var/www/html/live/conf \
      /var/www/html/live/data \
      /var/www/html/live/teams
