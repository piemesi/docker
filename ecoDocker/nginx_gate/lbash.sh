#!/bin/bash

#/usr/sbin/nginx

cd /opt/kafka-cluster
sh /opt/kafka-cluster/start_local.sh
service nginx start
cd /opt
sh ./install-dev.sh



#sudo 
#/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic parser
#install-dev on proto!!!
