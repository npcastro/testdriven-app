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
    echo "Pushing Users service"
    docker tag $USERS:$COMMIT $ECR_REPO/$USERS:$TAG
    docker push $ECR_REPO/$USERS:$TAG

    echo "Pushing Users DB service"
    docker tag $USERS_DB:$COMMIT $ECR_REPO/$USERS_DB:$TAG
    docker push $ECR_REPO/$USERS_DB:$TAG

    echo "Pushing Client service"
    docker tag $CLIENT:$COMMIT $ECR_REPO/$CLIENT:$TAG
    docker push $ECR_REPO/$CLIENT:$TAG

    echo "Pushing Swagger service"
    docker tag $SWAGGER:$COMMIT $ECR_REPO/$SWAGGER:$TAG
    docker push $ECR_REPO/$SWAGGER:$TAG
  fi
fi
