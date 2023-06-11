CURR_DIR=$(cd "$(dirname "$0")"; pwd)
REDIS_PORT_NUMBER=$1

if [ ! -f "$CURR_DIR/.env" ];then
  echo "file $CURR_DIR/.env is not exist"
  exit
fi

if [ "$REDIS_PORT_NUMBER" == "" ];then
  echo "REDIS_PORT_NUMBER is empty"
  exit
fi

echo "docker-compose -f docker-compose.$REDIS_PORT_NUMBER.yaml up -d"
docker-compose -f docker-compose.$REDIS_PORT_NUMBER.yaml up -d