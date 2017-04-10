#/usr/sbin/nginx

service nginx start




cd /opt/kafka-cluster
#export PATH=`dirname $0`/bin:$PATH
 ./start_local.sh

#exec("cd /home/sdc/webpath/one && /home/sdc/webpath/git.update/update.sh");

#GIT_DIR=/home/sdc/webpath/one update.sh

#sudo 
#/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic parser
#install-dev on proto!!!
