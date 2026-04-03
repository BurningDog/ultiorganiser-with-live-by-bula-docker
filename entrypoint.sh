#!/bin/sh
# Fix ownership of volume-mounted directories at startup.
# The Dockerfile chown only affects the image layer; volumes overlay it at runtime.
chown -R www-data:www-data \
  /var/www/html/conf \
  /var/www/html/images/uploads \
  /var/www/html/live/conf \
  /var/www/html/live/data \
  /var/www/html/live/teams

# Apply any patches in /patches/ against the codebase
for patch_file in /patches/*.patch; do
  [ -f "$patch_file" ] || continue
  echo "Applying patch: $patch_file"
  patch -p1 -N -d /var/www/html < "$patch_file" || true
done

exec apache2-foreground
