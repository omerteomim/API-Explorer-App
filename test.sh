#!/bin/bash
start_time=$(date +%s)
while true; do
    current_time=$(date +%s)
    elapsed_time=$(current_time - start_time)
    if [ $elapsed_time -ge 20 ]; then
        exit 1
for route in / /shoppinglist /pokemon /dogs /dadjokes /evilinsult /shoppinglist/delete/; do
    echo "Testing route: $route"
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000$route)
    if [ "$response" -eq 200 ]; then
    echo "Route $route is reachable."
    else
    echo "Route $route failed with status code $response."
    docker compose down
    exit 1
    fi
done
docker compose down 