FROM malgrat/ubuntu_base
MAINTAINER Alexey Gaynulin <w@gaynulin.ru>


ENV HOME /root 

#DEBIAN_FRONTEND="noninteractive" 
RUN apt-get update
RUN apt-get install openssh-client \
	apt-get install composer \
	apt install pkg-config automake autoconf libsigc++-2.0-dev supervisor nginx-light \
apt-get install curl

RUN  curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh |  bash \
	apt install php7.0-phalcon \
	apt-get update \
	apt-get -y upgrade
 
RUN apt-get -y install php7.0
RUN apt-get -y install php7.0-fpm php7.0-common php7.0-cli php7.0-mysqlnd php7.0-mcrypt php7.0-curl php7.0-bcmath php7.0-mbstring php7.0-soap php7.0-xml php7.0-zip php7.0-json php7.0-imap php-xdebug php-pgsql 


EXPOSE 80






#RUN apt-get -y upgrade 
#RUN apt-get update --fix-missing
#RUN apt-get -y install php7.0
#RUN apt-get -y install php7.0-fpm php7.0-common php7.0-cli php7.0-mysqlnd php7.0-mcrypt php7.0-#curl php7.0-bcmath php7.0-mbstring php7.0-soap php7.0-xml php7.0-zip php7.0-json php7.0-imap php-#xdebug php-pgsql

