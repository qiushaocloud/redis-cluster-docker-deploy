nodeName=cluster-redis-6373
if [ "$1" != "" ]; then
    nodeName=cluster-redis-$1
fi
echo "nodeName: $nodeName"

docker exec -it $nodeName bash
