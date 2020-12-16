#!/bin/sh
echo "Pulling services images from ECR"

# - export REPO=$AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_NAME
# - export REPO=$AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
# - docker pull $(REPO):$(TRAVIS_BRANCH)

# - docker build --cache-from $(REPO):$(TRAVIS_BRANCH) -t $(REPO):$(TRAVIS_COMMIT) .
