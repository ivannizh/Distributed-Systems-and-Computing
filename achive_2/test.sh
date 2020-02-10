curl -X POST \
  -H 'Content-Type: application/json' \
  -H 'Host: 127.0.0.1:5000' \
  -H 'cache-control: no-cache' \
  -d '{ "num": '$1' }' \
  http://127.0.0.1:5000/ 