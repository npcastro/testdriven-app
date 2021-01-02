if [ "$TRAVIS_BRANCH" == "production" ]
then
  export REACT_APP_USERS_SERVICE_URL=$(aws elbv2 describe-load-balancers --names testdriven-production-alb --query "LoadBalancers[0].DNSName" --output text --region us-east-1)
elif [ "$TRAVIS_BRANCH" == "staging" ]
then
  export REACT_APP_USERS_SERVICE_URL=$(aws elbv2 describe-load-balancers --names testdriven-staging-alb --query "LoadBalancers[0].DNSName" --output text --region us-east-1)
else
  export REACT_APP_USERS_SERVICE_URL=http://127.0.0.1
fi
