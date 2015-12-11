#!/bin/bash

/bin/sed -i "s/TTBZ_DB_ROOT_PASS/${MYSQL_ENV_MYSQL_ROOT_PASSWORD}/" /var/www/bugzilla/localconfig
/bin/sed -i "s/TTBZ_APP_SECRET_KEY/${TTBZ_APP_SECRET_KEY}/" /var/www/bugzilla/localconfig
echo "${TTBZ_APP_ADMIN_EMAIL}
${TTBZ_APP_ADMIN_REAL_NAME}
${TTBZ_APP_ADMIN_PASSWORD}
${TTBZ_APP_ADMIN_PASSWORD}" > /tmp/answer.txt
/var/www/bugzilla/checksetup.pl < /tmp/answer.txt
rm /tmp/answer.txt

/bin/sed -i "s/TTBZ_APP_SERVER_NAME/${TTBZ_APP_SERVER_NAME}/" /etc/apache2/sites-available/001-bugzilla.conf
/bin/sed -i "s/TTBZ_APP_SERVER_ADMIN/${TTBZ_APP_SERVER_ADMIN}/" /etc/apache2/sites-available/001-bugzilla.conf

/usr/sbin/apache2ctl -D FOREGROUND
