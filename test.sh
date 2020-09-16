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

# return proper code
if [ -n "${fails}" ]; then
  echo "Tests failed: ${fails}"
  exit 1
else
  echo "Tests passed!"
  exit 0
fi
