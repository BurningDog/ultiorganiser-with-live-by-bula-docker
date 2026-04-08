FROM php:8.2-apache

RUN apt-get update --assume-yes \
 && apt-get install --assume-yes zlib1g-dev libpng-dev libonig-dev gettext locales patch \
 # need git to get the commit information for the build if it's present
 # But the Live! by BULA codebase does not include a git commit history
 # && apt-get install --assume-yes git \
 && locale-gen en_GB.UTF-8 fi_FI.UTF-8 \
 && docker-php-ext-install mysqli gettext gd mbstring pdo_mysql \
 && a2enmod rewrite \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# PHP error reporting — uncomment one of the two options below:

# Option 1: Hide deprecation notices from browser output; still log them
# RUN echo "display_errors = Off\nerror_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE\nlog_errors = On" \
#     > /usr/local/etc/php/conf.d/errors.ini

# Option 2: Show all errors on screen (useful for active development)
RUN echo "display_errors = On\nerror_reporting = E_ALL\nlog_errors = On" \
    > /usr/local/etc/php/conf.d/errors.ini

# Allow .htaccess overrides for the document root
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' \
    /etc/apache2/apache2.conf

# Copy the entire folder
COPY uo-with-live-1.9.16/ /var/www/html/

# Config uses environment variables set in .env
COPY conf/config.inc.php /var/www/html/conf/

# Create upload directory (not present in source)
RUN mkdir -p /var/www/html/images/uploads

# We won't need the install file because we import the database file ourselves:
RUN rm -f /var/www/html/install.php

# Patches to apply against the codebase
COPY patch/*.patch /patches/
RUN for f in /patches/*.patch; do \
      echo "Applying patch: $f"; \
      patch --batch -p1 -d /var/www/html < "$f"; \
    done

# Entrypoint re-applies www-data ownership at startup, after volumes are mounted
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
