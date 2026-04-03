#!/bin/sh
# Fix ownership of volume-mounted directories at startup.
# The Dockerfile chown only affects the image layer; volumes overlay it at runtime.
chown -R www-data:www-data \
  /var/www/html/conf \
  /var/www/html/images/uploads \
  /var/www/html/live/conf \
  /var/www/html/live/data \
  /var/www/html/live/teams

exec apache2-foreground
