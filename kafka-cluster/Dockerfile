FROM malgrat/nginx_base

RUN apt-get update && \
    apt install -y default-jre

RUN apt-get update && \
    apt install -y git \
	apt-get install -y php7.0-dev



#ENTRYPOINT ["/opt"]
WORKDIR /opt

RUN mkdir kafka-cluster
RUN git clone https://github.com/edenhill/librdkafka.git 

RUN cd ./librdkafka \
	git checkout 0.9.3 \ 
	./configure \ 
	make \
	make install

#RUN cd /opt/kafka-cluster

# COPY ./kafka-cluster  /opt2/kafka-cluster

# CMD ["/opt2/kafka-cluster/start_local.sh"]
