#!/bin/bash

env=$1
fails=""

inspect() {
  if [ $1 -ne 0 ]; then
    fails="${fails} $2"
  fi
}

# run client and server-side tests
dev() {
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
}

# run e2e tests
e2e() {
  # docker-compose -f docker-compose-$1.yml up -d --build
  docker-compose -f docker-compose-stage.yml up -d
  docker-compose -f docker-compose-stage.yml run users python manage.py recreate_db
  ./node_modules/.bin/cypress run --config baseUrl=http://localhost --env REACT_APP_API_GATEWAY_URL=$REACT_APP_API_GATEWAY_URL,LOAD_BALANCER_DNS_NAME=$LOAD_BALANCER_DNS_NAME
  inspect $? e2e
  docker-compose -f docker-compose-stage.yml down
}

login() {
  aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS --password-stdin $ECR_REPO
}

# run appropriate tests
if [[ "${env}" == "staging" ]] || [[ "${env}" == "production" ]]; then
  echo "Running e2e tests!"
  login
  e2e
else
  echo "Running client and server-side tests!"
  dev
fi

# return proper code
if [ -n "${fails}" ]; then
  echo "Tests failed: ${fails}"
  exit 1
else
  echo "Tests passed!"
  exit 0
fi
