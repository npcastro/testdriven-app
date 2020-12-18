#!/bin/sh

pull_and_build() {
  echo "Pulling services images from ECR"
  export TAG=$TRAVIS_BRANCH
  env=$1

  ls -l
  ls -l ./services

  # users
  docker pull $ECR_REPO/$USERS:$TAG
  docker build ./services/users --cache-from $ECR_REPO/$USERS:$TAG -f ./services/users/Dockerfile-$env

  # users db
  docker pull $ECR_REPO/$USERS_DB:$TAG
  docker build ./services/users/project/db --cache-from $ECR_REPO/$USERS_DB:$TAG -f ./services/users/project/db/Dockerfile

  # client
  docker pull $ECR_REPO/$CLIENT:$TAG
  docker build ./services/client --cache-from $ECR_REPO/$CLIENT:$TAG -f ./services/client/Dockerfile-$env

  # swagger
  docker pull $ECR_REPO/$SWAGGER:$TAG
  docker build ./services/swagger --cache-from $ECR_REPO/$SWAGGER:$TAG -f ./services/swagger/Dockerfile-$env
}

curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws

aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS --password-stdin $ECR_REPO

if [ "$TRAVIS_BRANCH" == "staging" ]
then
  pull_and_build stage
elif [ "$TRAVIS_BRANCH" == "production" ]
then
  pull_and_build prod
fi
