# Microservices with Docker, Flask, and React

[![Build Status](https://travis-ci.com/npcastro/testdriven-app.svg?branch=master)](https://travis-ci.com/npcastro/testdriven-app)

## Cheatsheet

1. Make sure that the EC2 machines are terminated

2. Create EC2 machines with docker
docker-machine create --driver amazonec2 testdriven-staging

3. Point the Docker Engine to the new machine
eval $(docker-machine env testdriven-staging)

4. Grab the IP for the new staging machine
DOCKER_MACHINE_STAGING_IP=$(docker-machine ip testdriven-staging)

5. Update the REACT_APP_USERS_SERVICE_URL environment variable
export REACT_APP_USERS_SERVICE_URL=http://$DOCKER_MACHINE_STAGING_IP

6. Spin up the containers
docker-compose -f docker-compose-stage.yml up -d --build

7. E2E tests
./node_modules/.bin/cypress open --config baseUrl=http://$DOCKER_MACHINE_STAGING_IP
