#!/bin/sh

aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS --password-stdin $ECR_REPO

echo "Pulling services images from ECR"
export TAG=$TRAVIS_BRANCH

echo "Pulling Users service"
docker pull $ECR_REPO/$USERS:$TAG

echo "Pulling Users DB service"
docker pull $ECR_REPO/$USERS_DB:$TAG

echo "Pulling Client service"
docker pull $ECR_REPO/$CLIENT:$TAG

echo "Pulling Swagger service"
docker pull $ECR_REPO/$SWAGGER:$TAG
