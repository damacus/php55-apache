#!/bin/bash
set -e

if [ "$USER" = "root" ]; then

    # set localtime
    ln -sf /usr/share/zoneinfo/$LOCALTIME /etc/localtime

    # secure path
    chmod a-rwx -R /etc/apache2/ $PHP_INI_DIR/ /etc/ssmtp
fi

#
# functions

function set_conf {
    echo ''>$2; IFSO=$IFS; IFS=$(echo -en "\n\b")
    for c in `printenv|grep $1`; do echo "`echo $c|cut -d "=" -f1|awk -F"$1" '{print $2}'` $3 `echo $c|cut -d "=" -f2`" >> $2; done;
    IFS=$IFSO
}

#
# APACHE

if [ ! -d "$HTTPD__DocumentRoot" ]; then echo >&2 "[Error] Document Root Directory not exist (please create $HTTPD__DocumentRoot)"; exit 1; fi
if [ "$HTTPD_a2enmod" != "" ]; then a2enmod $HTTPD_a2enmod > /dev/null; fi;
set_conf "HTTPD__" "$HTTPD_CONF_DIR/40-user.conf" ""

#
# PHP

echo "date.timezone = \"${LOCALTIME}\"" >> $PHP_INI_DIR/conf.d/00-default.ini
if [ "$PHP_php5enmod" != "" ]; then docker-php-ext-enable $PHP_php5enmod > /dev/null 2>&1; fi;
set_conf "PHP__" "$PHP_INI_DIR/conf.d/40-user.ini" "="

#
# Run

if [[ ! -z "$1" ]]; then
    exec ${*}
else
    exec apache2-foreground
fi
