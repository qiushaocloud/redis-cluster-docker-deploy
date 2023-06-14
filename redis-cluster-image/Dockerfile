FROM redis:latest

RUN apt-get update \
	&& apt-get install -y iputils-ping telnet

COPY ./run-redis-server.sh /run-redis-server.sh
COPY ./run-create-cluster.sh /run-create-cluster.sh

RUN chmod +x /run-redis-server.sh \
	&& chmod +x /run-create-cluster.sh

CMD ["bash", "/run-redis-server.sh"]