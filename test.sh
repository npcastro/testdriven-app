#!/bin/bash

fails=""

inspect() {
  if [ $1 -ne 0 ]; then
    fails="${fails} $2"
  fi
}

# spin up containers
docker-compose up -d --build

# run tests
docker-compose exec users python manage.py test
inspect $? users
docker-compose exec users flake8 project
inspect $? users-lint
docker-compose exec client npm run coverage
inspect $? client

# turn off containers
docker-compose down

# run e2e tests
docker-compose up -d --build
docker-compose exec users python manage.py recreate_db
./node_modules/.bin/cypress run --config baseUrl=http://localhost
inspect $? e2e
docker-compose -f docker-compose-prod.yml down

# return proper code
if [ -n "${fails}" ]; then
  echo "Tests failed: ${fails}"
  exit 1
else
  echo "Tests passed!"
  exit 0
fi
