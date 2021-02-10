#!/usr/bin/env sh

build() {
  mkdir -p backend/bin
  GOOS=linux go build -o "backend/bin/$1" "./backend/cmd/$1"
}

package() {
  (cd backend/bin && zip "$1.zip" "$1")
}

deploy() {
  AWS_PAGER='' aws lambda update-function-code \
    --profile goggle --region us-west-2 \
    --function-name "goggle-$1" --zip-file "fileb://backend/bin/$1.zip" --publish
}

echo 'Building backend' &&
  build restapi &&
  build wsapi &&
  echo 'Packaging backend' &&
  package restapi &&
  package wsapi &&
  echo 'Deploying backend' &&
  deploy restapi &&
  deploy wsapi
