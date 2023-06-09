REDIS_PORT=$1

if [ "$REDIS_PORT" == "" ];then
  echo "REDIS_PORT is empty"
  exit
fi

if [ "$REDIS_PORT" == "6375" ] && [ "%REDIS_CLUSTER_REPLICAS" == "0" ]; then
  echo "docker-compose -f docker-compose.$REDIS_PORT.create-cluster.only-master.yaml down -v"
  docker-compose -f docker-compose.$REDIS_PORT.create-cluster.only-master.yaml down -v
elif [ "$REDIS_PORT" == "6378" ]; then
  echo "docker-compose -f docker-compose.$REDIS_PORT.create-cluster.yaml down -v"
  docker-compose -f docker-compose.$REDIS_PORT.create-cluster.yaml down -v
else
  echo "docker-compose -f docker-compose.$REDIS_PORT.yaml down -v"
  docker-compose -f docker-compose.$REDIS_PORT.yaml down -v
fi