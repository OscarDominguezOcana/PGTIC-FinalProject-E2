k exec -it details-v1-5498c86cf5-wdzxx -c istio-proxy bash

for i in $(seq 1 800); do curl -s -o /dev/null "http://productpage.default.svc.cluster.local:9080/productpage"; done