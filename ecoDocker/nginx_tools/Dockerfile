FROM malgrat/nginx_base:tutumubuntu_phalcon

#COPY ./local.php /var/l/var/www/local.php

#VOLUME ["/etc/nginx/sites-available/default"]
#VOLUME ["/etc/nginx/sites-enabled/"]

WORKDIR /opt/kafka-cluster
RUN ./start_local.sh

CMD ["/bin/bash"]
#ENTRYPOINT ["/usr/sbin/nginx"]
ENTRYPOINT ["./lbash.sh"]

#ENTRYPOINT ["/etc/entrypoint.sh"]
