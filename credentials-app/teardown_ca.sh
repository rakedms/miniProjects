#!/bin/bash
source ./terminal_control.sh

cd ./credentials-app/docker/

print Red "========== Bringing down the CA Containers and Pruning Volumes =========="
docker-compose -f docker-compose-ca.yaml down -v
