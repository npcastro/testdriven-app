#!/bin/sh

pull_and_build() {
  echo "Pulling services images from ECR"
  export TAG=$TRAVIS_BRANCH
  env=$1

  # users
  docker pull $ECR_REPO/$USERS:$TAG
  docker build --cache-from $ECR_REPO/$USERS:$TAG -f Dockerfile-$env ./services/users

  # users db
  docker pull $ECR_REPO/$USERS_DB:$TAG
  docker build --cache-from $ECR_REPO/$USERS_DB:$TAG -f Dockerfile ./services/users/project/db

  # client
  docker pull $ECR_REPO/$CLIENT:$TAG
  docker build --cache-from $ECR_REPO/$CLIENT:$TAG -f Dockerfile-$env ./services/client

  # swagger
  docker pull $ECR_REPO/$SWAGGER:$TAG
  docker build --cache-from $ECR_REPO/$SWAGGER:$TAG -f Dockerfile-$env ./services/swagger
}


aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS --password-stdin $ECR_REPO

if [ "$TRAVIS_BRANCH" == "staging" ]
then
  pull_and_build stage
elif [ "$TRAVIS_BRANCH" == "production" ]
then
  pull_and_build prod
fi
