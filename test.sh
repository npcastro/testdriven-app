#!/bin/bash


type=$1
fails=""

inspect() {
  if [ $1 -ne 0 ]; then
    fails="${fails} $2"
  fi
}

server() {
  docker-compose up -d --build
  docker-compose exec users python manage.py test
  inspect $? users
  docker-compose exec users flake8 project
  inspect $? users-lint
  docker-compose exec exercises python manage.py test
  inspect $? exercises
  docker-compose exec exercises flake8 project
  inspect $? exercises-lint
  docker-compose exec scores python manage.py test
  inspect $? scores
  docker-compose exec scores flake8 project
  inspect $? scores-lint
  docker-compose down
}

client() {
  docker-compose up -d --build
  docker-compose exec client npm test -- --coverage --watchAll=false
  inspect $? client
  docker-compose down
}

e2e() {
  docker-compose -f docker-compose-stage.yml up -d --build
  docker-compose -f docker-compose-stage.yml exec users python manage.py recreate_db
  ./node_modules/.bin/cypress run --config baseUrl=http://localhost --env REACT_APP_API_GATEWAY_URL=$REACT_APP_API_GATEWAY_URL,LOAD_BALANCER_DNS_NAME=http://localhost
  inspect $? e2e
  docker-compose -f docker-compose-stage.yml down
}

all() {
  docker-compose up -d --build
  docker-compose exec users python manage.py test
  inspect $? users
  docker-compose exec users flake8 project
  inspect $? users-lint
  docker-compose exec exercises python manage.py test
  inspect $? exercises
  docker-compose exec exercises flake8 project
  inspect $? exercises-lint
  docker-compose exec scores python manage.py test
  inspect $? scores
  docker-compose exec scores flake8 project
  inspect $? scores-lint
  docker-compose exec client npm test -- --coverage --watchAll=false
  inspect $? client
  docker-compose down
  e2e
}

# run appropriate tests
if [[ "${type}" == "server" ]]; then
  echo "\n"
  echo "Running server-side tests!\n"
  server
elif [[ "${type}" == "client" ]]; then
  echo "\n"
  echo "Running client-side tests!\n"
  client
elif [[ "${type}" == "e2e" ]]; then
  echo "\n"
  echo "Running e2e tests!\n"
  e2e
else
  echo "\n"
  echo "Running all tests!\n"
  all
fi

# return proper code
if [ -n "${fails}" ]; then
  echo "\n"
  echo "Tests failed: ${fails}"
  exit 1
else
  echo "\n"
  echo "Tests passed!"
  exit 0
fi
