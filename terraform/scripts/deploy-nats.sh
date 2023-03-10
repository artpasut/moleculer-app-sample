#!/bin/bash
while getopts i:s: flag
do
    case "${flag}" in
        i) image=${OPTARG};;
        s) service=${OPTARG};;
    esac
done
echo "Pull docker image..."
docker pull $image
echo "Stop existing services..."
docker stop $service
docker rm $service
echo "Running new services..."
docker run --name $service \
  -p 4222:4222 \
  --restart=unless-stopped \
  -d $image
