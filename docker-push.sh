#!/bin/sh

if [ -z "$TRAVIS_PULL_REQUEST" ] || [ "$TRAVIS_PULL_REQUEST" == "false" ]
then

  if [[ "$TRAVIS_BRANCH" == "staging" ]]; then
    export DOCKER_ENV=stage
  elif [[ "$TRAVIS_BRANCH" == "production" ]]; then
    export DOCKER_ENV=prod
  fi

  if [ "$TRAVIS_BRANCH" == "staging" ] || \
     [ "$TRAVIS_BRANCH" == "production" ]
  then
    export PATH=~/bin:$PATH
    export TAG=$TRAVIS_BRANCH
    # AWS_ACCOUNT_ID, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY must be set on travis
    aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS \
        --password-stdin $ECR_REPO

  fi

  if [ "$TRAVIS_BRANCH" == "staging" ] || \
     [ "$TRAVIS_BRANCH" == "production" ]
  then
    # users
    docker build $USERS_REPO -t $USERS:$COMMIT -f Dockerfile-$DOCKER_ENV
    docker tag $USERS:$COMMIT $ECR_REPO/$USERS:$TAG
    docker push $ECR_REPO/$USERS:$TAG
    # users db
    docker build $USERS_DB_REPO -t $USERS_DB:$COMMIT -f Dockerfile
    docker tag $USERS_DB:$COMMIT $ECR_REPO/$USERS_DB:$TAG
    docker push $ECR_REPO/$USERS_DB:$TAG
    # client
    docker build $CLIENT_REPO -t $CLIENT:$COMMIT -f Dockerfile-$DOCKER_ENV --build-arg REACT_APP_USERS_SERVICE_URL=TBD
    docker tag $CLIENT:$COMMIT $ECR_REPO/$CLIENT:$TAG
    docker push $ECR_REPO/$CLIENT:$TAG
    # swagger
    docker build $SWAGGER_REPO -t $SWAGGER:$COMMIT -f Dockerfile-$DOCKER_ENV
    docker tag $SWAGGER:$COMMIT $ECR_REPO/$SWAGGER:$TAG
    docker push $ECR_REPO/$SWAGGER:$TAG
  fi
fi
