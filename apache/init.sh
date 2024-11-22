#!/bin/bash

for conf in /etc/apache2/sites-available/*.conf; do
    a2ensite $(basename $conf)
done
echo "ServerName ${SERVER_NAME}" > /etc/apache2/conf-available/servername.conf
a2enconf servername.conf
apache2ctl configtest

