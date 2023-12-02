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

cp -ra docker-compose.sentinel.REDIS_PORT_NUMBER.yaml.tpl docker-compose.sentinel.$REDIS_PORT_NUMBER.yaml
sed -i "s#<REDIS_PORT_NUMBER>#${REDIS_PORT_NUMBER}#g" docker-compose.sentinel.$REDIS_PORT_NUMBER.yaml

echo "docker-compose -f docker-compose.sentinel.$REDIS_PORT_NUMBER.yaml up -d"
docker-compose -f docker-compose.sentinel.$REDIS_PORT_NUMBER.yaml up -d