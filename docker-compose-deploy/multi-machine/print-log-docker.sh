REDIS_PORT=$1

if [ "$REDIS_PORT" == "" ];then
  echo "REDIS_PORT is empty"
  exit
fi

echo "docker-compose -f docker-compose.$REDIS_PORT.yaml logs -f"
docker-compose -f docker-compose.$REDIS_PORT.yaml logs -f