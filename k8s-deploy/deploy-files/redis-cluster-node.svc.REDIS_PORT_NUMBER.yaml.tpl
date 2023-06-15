apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-node-svc-<REDIS_PORT_NUMBER>
  namespace: redis
spec:
  type: <K8S_SVC_TYPE>
  clusterIP: None
  selector:
    app: redis-cluster-node-<REDIS_PORT_NUMBER>
    svc-headless: redis-cluster-headless
  ports:
    - name: redis-cluster-node-port-<REDIS_PORT_NUMBER>
      port: <REDIS_PORT_NUMBER>
      targetPort: <REDIS_PORT_NUMBER>
      nodePort: <REDIS_PORT_NUMBER>
    - name: redis-cluster-node-announce-bus-port-<REDIS_PORT_NUMBER>
      port: 1<REDIS_PORT_NUMBER>
      targetPort: 1<REDIS_PORT_NUMBER>
      nodePort: 1<REDIS_PORT_NUMBER>