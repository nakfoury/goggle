#!/usr/bin/env sh

AWS_PAGER='' \
  cd client &&
  echo 'Building client' &&
  yarn run build &&
  echo 'Deploying client' &&
  aws s3 sync public s3://freewordgame.com --profile goggle --region us-west-2 \
    --cache-control max-age=60 --no-progress
