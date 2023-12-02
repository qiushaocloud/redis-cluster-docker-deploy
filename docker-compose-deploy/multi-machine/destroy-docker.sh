REDIS_PORT_NUMBER=$1

if [ "$REDIS_PORT_NUMBER" == "" ];then
  echo "REDIS_PORT_NUMBER is empty"
  exit
fi

echo "docker-compose -f docker-compose.$REDIS_PORT_NUMBER.yaml down -v"
docker-compose -f docker-compose.$REDIS_PORT_NUMBER.yaml down -v