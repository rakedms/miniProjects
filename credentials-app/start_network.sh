#!/bin/bash
source ./terminal_control.sh

cd ./credentials-app/docker/

print Green "========== Bringing up the docker containers =========="
docker-compose -f docker-compose.yaml up -d