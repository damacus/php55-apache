FROM php:5.5-apache

LABEL org.label-schema.name "php55-apache"
LABEL org.label-schema.description "PHP 5.5 with Apache2"
LABEL org.label-schema.maintainer "Dan Webb"
LABEL org.label-schema.vcs-url "https://github.com/damacus/php55-apache"
ARG date
LABEL org.label-schema.build-date=$date

ENV HTTPD_CONF_DIR /etc/apache2/conf-enabled/
ENV HTTPD__DocumentRoot /var/www/html
ENV HTTPD__LogFormat '"%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" common'
RUN sed -i "s/DocumentRoot.*/DocumentRoot \${HTTPD__DocumentRoot}/"  /etc/apache2/apache2.conf && \
    echo 'ServerName ${HOSTNAME}' > $HTTPD_CONF_DIR/00-default.conf && \
    chmod a+w -R $HTTPD_CONF_DIR/ /etc/apache2/mods-enabled/ $PHP_INI_DIR/
COPY docker-entrypoint.sh /entrypoint.sh

WORKDIR /var/www

ENTRYPOINT ["/entrypoint.sh"]
