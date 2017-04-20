FROM percona/percona-server:latest

ADD ./filler.sql /tmp/filler.sql

ADD ./init_db.sh /tmp/init_db.sh
RUN /tmp/init_db.sh

VOLUME /var/lib/mysql

#RUN /bin/bash -c "/usr/bin/mysqld_safe &" && \
#  sleep 5 && \
#  mysql -u root -p 123456 "CREATE DATABASE mydb" #&& \
#  mysql -u root mydb < "CREATE TABLE testing"

#./filler.sql

CMD ['true']


