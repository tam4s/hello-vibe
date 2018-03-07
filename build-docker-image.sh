#!/usr/bin/env sh
IMG_NAME=tam4s/hello-vibe-$(uname -m)

docker build -t $IMG_NAME .
docker login
docker push $IMG_NAME
