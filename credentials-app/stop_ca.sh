#!/bin/bash
source ./terminal_control.sh

print Red "========== Stopping the Containers =========="
cd ./credentials-app/docker/
docker-compose -f docker-compose-ca.yaml stop