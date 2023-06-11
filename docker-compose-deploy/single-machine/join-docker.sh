nodeName=redis-cluster-node-6373
if [ "$1" != "" ]; then
    nodeName=redis-cluster-$1
fi
echo "nodeName: $nodeName"

docker exec -it $nodeName bash
