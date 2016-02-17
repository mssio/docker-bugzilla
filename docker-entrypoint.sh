#!/bin/bash

cd /var/www/bugzilla

if ! [ -e /var/www/bugzilla/index.cgi ]; then
  echo "Bugzilla not exist copy it from source"
  tar cf - --one-file-system -C /usr/src/bugzilla . | tar xf -
else
  echo "Bugzilla exist, skip copy from source"
fi

/bin/cp /usr/src/bugzilla/localconfig /var/www/bugzilla/localconfig

/usr/bin/perl /var/www/bugzilla/install-module.pl Email::Send
/usr/bin/perl /var/www/bugzilla/install-module.pl --all

/bin/sed -i "s/MSSBZ_APP_DB_NAME/${MSSBZ_APP_DB_NAME}/" /var/www/bugzilla/localconfig
/bin/sed -i "s/MSSBZ_APP_DB_USER/${MSSBZ_APP_DB_USER}/" /var/www/bugzilla/localconfig
/bin/sed -i "s/MSSBZ_APP_DB_PASS/${MSSBZ_APP_DB_PASS}/" /var/www/bugzilla/localconfig
/bin/sed -i "s/MSSBZ_APP_SECRET_KEY/${MSSBZ_APP_SECRET_KEY}/" /var/www/bugzilla/localconfig

echo "${MSSBZ_APP_ADMIN_EMAIL}
${MSSBZ_APP_ADMIN_REAL_NAME}
${MSSBZ_APP_ADMIN_PASSWORD}
${MSSBZ_APP_ADMIN_PASSWORD}" > /tmp/answer.txt
/usr/bin/perl /var/www/bugzilla/checksetup.pl < /tmp/answer.txt
/bin/rm /tmp/answer.txt

/bin/sed -i "s/MSSBZ_APP_SERVER_NAME/${MSSBZ_APP_SERVER_NAME}/" /etc/apache2/sites-available/001-bugzilla.conf

/usr/sbin/apache2ctl -D FOREGROUND
