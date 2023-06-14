FROM redis:latest

RUN cp -ra /etc/apt/sources.list /etc/apt/sources.list.backup

COPY ./sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y iputils-ping telnet vim

COPY ./run-redis-server.sh /run-redis-server.sh
COPY ./run-create-cluster.sh /run-create-cluster.sh

RUN chmod +x /run-redis-server.sh \
	&& chmod +x /run-create-cluster.sh

CMD ["bash", "/run-redis-server.sh"]