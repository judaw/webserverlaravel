FROM ubuntu:latest

RUN apt update --fix-missing

# FIX TIMEZONE ISSUE
RUN apt install tzdata -y

# UTILS THAT ARE NEEDED
RUN apt install vim git zip wget curl -y

# STYLE TOOLS LESS AND COMPASS
# RUN apt install npm -y && npm install -g less
# RUN apt install ruby-compass -y && gem install sass-globbing

# FIX TIMEZONE ISSUE FULL
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# APACHE2 NEEDED
RUN apt-get install apache2 -y && a2enmod rewrite ssl

# MYSQL CLIENT TO CONNECT BACK TO NETWORKED MYSQL CONTAINER
RUN apt-get install mysql-client -y

# PHP NEEDED - DEFAULT UBUNTU IS PHP7.2
# RUN apt-get update -y --fix-missing
# RUN apt-get install -y php
# RUN apt-get install -y php-common	php-curl	php-gd	php-xml	php-mysql	php-mbstring	php-zip  php-ldap php-imagick php-soap
# RUN apt-get install -y libapache2-mod-php
# RUN service apache2 restart

# GET ALTERNATIVE PHP VERSIONS IF YOU DON'T WANT STANDARD
RUN apt-get install -y software-properties-common apt-utils language-pack-en-base
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

# PHP 7.3
RUN apt-get update -y --fix-missing
RUN apt-get install -y php7.3
RUN apt-get install -y php7.3-common	php7.3-curl	php7.3-gd	php7.3-xml	php7.3-mysql	php7.3-mbstring	php7.3-zip  php7.3-ldap php7.3-imagick
RUN apt-get install -y libapache2-mod-php7.3
RUN update-alternatives --set php /usr/bin/php7.3 && service apache2 restart

# NPM
# RUN apt-get install npm -y
# RUN npm install -g node-sass
# node-sass --output-style expanded --output /app/docroot/sites/scl/themes/custom/cwd_scl/css --source-map true

# COMPOSER INSTALL
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php && mv composer.phar /usr/local/bin/composer && php -r "unlink('composer-setup.php');"

# INSTALL LARAVEL CLIENT
RUN composer global require laravel/installer

# UPDATE AND CLEANUP
RUN apt-get dist-upgrade -y && apt-get autoremove -y

# Create bashrc
RUN echo 'export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "'  >> /root/.bashrc
RUN echo 'export CLICOLOR=1'  >> /root/.bashrc
RUN echo 'export LSCOLORS=ExFxBxDxCxegedabagacad'  >> /root/.bashrc

#Logging
RUN echo "alias weblog='tail /var/log/apache2/error.log'"  >> /root/.bashrc

#Compile Sass
# RUN echo "compilesass() {"  >> /root/.bashrc
# RUN echo "node-sass --output-style expanded --output \$1 --source-map true \$2"  >> /root/.bashrc
# RUN echo "}"  >> /root/.bashrc

#Laravel CLI
RUN echo 'export PATH="$PATH:/root/.composer/vendor/bin"' >> /root/.bashrc

#Sourcing
RUN /bin/bash -c "source /root/.bashrc"

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
