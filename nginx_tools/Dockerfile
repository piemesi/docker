FROM malgrat/nginx_base:tutumubuntu_phalcon
MAINTAINER w@gaynulin.ru

VOLUME  /etc/nginx/sites-available  /etc/nginx/sites-enabled
 
RUN service nginx stop


RUN apt-get update && \
    apt-get install -y nano && \
    apt-get clean 



RUN mv /etc/nginx/sites-available /etc/nginx/sites-available2
RUN mv /etc/nginx/sites-enabled /etc/nginx/sites-enabled2
RUN service nginx start 

#RUN echo "daemon off;" >> /etc/nginx/nginx.conf
#ADD sites-enabled/ /etc/nginx/sites-enabled/
#ADD app/ /app/


EXPOSE 80

#CMD ["/usr/sbin/nginx"]


# Install Nginx.
#RUN \
#  add-apt-repository -y ppa:nginx/stable && \
# apt-get update && \
#  apt-get install -y nginx-light && \
#  rm -rf /var/lib/apt/lists/* && \
#  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
#  chown -R www-data:www-data /var/lib/nginx

#RUN apt-get update && apt-get install -y pkg-config automake autoconf libsigc++-2.0-dev nginx-light #supervisor 

# Define mountable directories.
#VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/#www/html"]

# Define working directory.
#WORKDIR /etc/nginx

# Define default command.
#CMD ["nginx"]
#CMD ["nginx", "-g", "daemon off;"]
#CMD "/usr/sbin/nginx"

#RUN service nginx start
# Expose ports.
#EXPOSE 80
#EXPOSE 443




#RUN apt-get update && apt-get install -y php7.0 \
#  php7.0-fpm \
#  php7.0-mysql \
#  php7.0-curl \
#  php7.0-json \
#  php7.0-cgi

# Create Nginx log directory
#RUN mkdir -p /var/log/nginx

# Copy our nginx config
#RUN rm -Rf /etc/nginx/nginx.conf
#ADD conf/nginx.conf /etc/nginx/nginx.conf

# Configure Nginx
#RUN mkdir -p /etc/nginx/sites-available/ && \
#mkdir -p /etc/nginx/sites-enabled/ && \
#rm -Rf /var/www/* && \
#mkdir -p /var/www/html/ &&\
#touch /var/www/html/index.html && \
#echo hello world > /var/www/html/index.html && \
#echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

#RUN rm /etc/nginx/sites-available/default
#ADD conf/nginx-site.conf /etc/nginx/sites-available/default.conf
#RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# Copy Supervisor Conf.  Supervisor will manager nginx and fpm
#ADD conf/supervisord.conf /etc/supervisord.conf

# Make port 80 available for links and/or publish
#EXPOSE 80

# Add supervisor startup script and set to executable
#ADD start_super.sh /usr/local/bin/start_super.sh
#RUN chmod +x /usr/local/bin/start_super.sh

# replace the fpm socket with tcp connection
#RUN sed -i 's|listen = /run/php/php7.0-fpm.sock|listen = 127.0.0.1:9000|' /etc/php/7.0/fpm/pool.d/www.conf
# enable env variable reference to fpm
#RUN sed -i 's|;clear_env = no|clear_env = no|' /etc/php/7.0/fpm/pool.d/www.conf

# Define our command to be run when launching the container
#CMD ["/usr/local/bin/start_super.sh"]
