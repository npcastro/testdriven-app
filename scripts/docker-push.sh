#!/bin/sh

if [ -z "$TRAVIS_PULL_REQUEST" ] || [ "$TRAVIS_PULL_REQUEST" == "false" ]
then

  if [[ "$TRAVIS_BRANCH" == "staging" ]]; then
    export DOCKER_ENV=stage
    export REACT_APP_USERS_SERVICE_URL="http://testdriven-staging-alb-357083246.us-east-1.elb.amazonaws.com"
    export REACT_APP_EXERCISES_SERVICE_URL="http://testdriven-staging-alb-357083246.us-east-1.elb.amazonaws.com"
    export REACT_APP_SCORES_SERVICE_URL="http://testdriven-staging-alb-357083246.us-east-1.elb.amazonaws.com"
  elif [[ "$TRAVIS_BRANCH" == "production" ]]; then
    export DOCKER_ENV=prod
    export REACT_APP_USERS_SERVICE_URL="http://testdriven-production-alb-1778330533.us-east-1.elb.amazonaws.com"
    export REACT_APP_EXERCISES_SERVICE_URL="http://testdriven-production-alb-1778330533.us-east-1.elb.amazonaws.com"
    export REACT_APP_SCORES_SERVICE_URL="http://testdriven-production-alb-1778330533.us-east-1.elb.amazonaws.com"
    export DATABASE_URL="$AWS_RDS_URI"  # new
    export SECRET_KEY="$PRODUCTION_SECRET_KEY"  # new
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
    docker build $USERS_REPO --cache-from $ECR_REPO/$USERS:$TAG -f Dockerfile-$DOCKER_ENV -t $USERS:$COMMIT
    docker tag $USERS:$COMMIT $ECR_REPO/$USERS:$TAG
    docker push $ECR_REPO/$USERS:$TAG

    echo "Pushing Users DB service"
    docker build $USERS_DB_REPO --cache-from $ECR_REPO/$USERS_DB:$TAG -f Dockerfile -t $USERS_DB:$COMMIT
    docker tag $USERS_DB:$COMMIT $ECR_REPO/$USERS_DB:$TAG
    docker push $ECR_REPO/$USERS_DB:$TAG

    echo "Pushing Client service"
    docker build $CLIENT_REPO --cache-from $ECR_REPO/$CLIENT:$TAG -f Dockerfile-$DOCKER_ENV -t $CLIENT:$COMMIT \
      --build-arg REACT_APP_USERS_SERVICE_URL=$REACT_APP_USERS_SERVICE_URL \
      --build-arg REACT_APP_EXERCISES_SERVICE_URL=$REACT_APP_EXERCISES_SERVICE_URL \
      --build-arg REACT_APP_API_GATEWAY_URL=$REACT_APP_API_GATEWAY_URL \
      --build-arg REACT_APP_SCORES_SERVICE_URL=$REACT_APP_SCORES_SERVICE_URL
    docker tag $CLIENT:$COMMIT $ECR_REPO/$CLIENT:$TAG
    docker push $ECR_REPO/$CLIENT:$TAG

    echo "Pushing Swagger service"
    docker build $SWAGGER_REPO --cache-from $ECR_REPO/$SWAGGER:$TAG -f Dockerfile-$DOCKER_ENV -t $SWAGGER:$COMMIT
    docker tag $SWAGGER:$COMMIT $ECR_REPO/$SWAGGER:$TAG
    docker push $ECR_REPO/$SWAGGER:$TAG

    echo "Pushing Exercises service"
    docker build $EXERCISES_REPO --cache-from $ECR_REPO/$EXERCISES:$TAG -t $EXERCISES:$COMMIT -f Dockerfile-$DOCKER_ENV
    docker tag $EXERCISES:$COMMIT $ECR_REPO/$EXERCISES:$TAG
    docker push $ECR_REPO/$EXERCISES:$TAG

    echo "Pushing Exercises DB service"
    docker build $EXERCISES_DB_REPO --cache-from $ECR_REPO/$EXERCISES_DB:$TAG -t $EXERCISES_DB:$COMMIT -f Dockerfile
    docker tag $EXERCISES_DB:$COMMIT $ECR_REPO/$EXERCISES_DB:$TAG
    docker push $ECR_REPO/$EXERCISES_DB:$TAG
  fi
fi
