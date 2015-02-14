FROM ubuntu:trusty
MAINTAINER Thomas Ferney <thomas.ferney@gmail.com>

# Install base packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-gd \
        php5-curl \
        php-pear \
        php5-intl \
        php5-imagick \
        php5-imap \
        php5-mcrypt \
        php5-memcache \
        php5-ming && \
    apt-get -yq install \
        php5-ps \
        php5-pspell \ 
        php5-recode \
        php5-snmp \ 
        php5-xmlrpc \ 
        php5-xsl \
        php-apc && \
    rm -rf /var/lib/apt/lists/*
RUN sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD custom.conf /etc/apache2/sites-available/custom.conf

# Configure /var/www/app folder
RUN mkdir -p /var/www/app

RUN a2dissite 000-default.conf 
RUN a2ensite custom.conf

EXPOSE 80
WORKDIR /var/www/app
CMD ["/run.sh"]