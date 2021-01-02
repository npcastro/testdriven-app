#!/bin/sh

pull_and_build() {
  echo "Pulling services images from ECR"
  export TAG=$TRAVIS_BRANCH
  env=$1

  echo "Pulling Users service"
  docker pull $ECR_REPO/$USERS:$TAG
  # docker build $USERS_REPO --cache-from $ECR_REPO/$USERS:$TAG -f Dockerfile-$env -t $USERS:$COMMIT

  echo "Pulling Users DB service"
  docker pull $ECR_REPO/$USERS_DB:$TAG
  # docker build $USERS_DB_REPO --cache-from $ECR_REPO/$USERS_DB:$TAG -f Dockerfile -t $USERS_DB:$COMMIT

  echo "Pulling Client service"
  docker pull $ECR_REPO/$CLIENT:$TAG
  # docker build $CLIENT_REPO --cache-from $ECR_REPO/$CLIENT:$TAG -f Dockerfile-$env -t $CLIENT:$COMMIT \
  #   --build-arg REACT_APP_USERS_SERVICE_URL=$REACT_APP_USERS_SERVICE_URL

  echo "Pulling Swagger service"
  docker pull $ECR_REPO/$SWAGGER:$TAG
  # docker build $SWAGGER_REPO --cache-from $ECR_REPO/$SWAGGER:$TAG -f Dockerfile-$env -t $SWAGGER:$COMMIT
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
