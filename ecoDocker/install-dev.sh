#!/usr/bin/env bash

touch test1.txt

/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic parser
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic br
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic blogic
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic fraudstop
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic mpi
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic ps
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic billing
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 5 --topic callback
/opt/kafka-cluster/dist/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 2 --partitions 3 --topic failhandler
