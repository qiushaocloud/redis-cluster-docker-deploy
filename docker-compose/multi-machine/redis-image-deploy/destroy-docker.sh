REDIS_PORT=$1

if [ "$REDIS_PORT" == "" ];then
  echo "REDIS_PORT is empty"
  exit
fi

docker-compose -f docker-compose.$REDIS_PORT.yaml down -v