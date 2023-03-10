#!/bin/bash
while getopts i:s:e: flag
do
    case "${flag}" in
        i) image=${OPTARG};;
        s) service=${OPTARG};;
        e) env_file=${OPTARG};;
    esac
done
aws --region=ap-southeast-1 ssm get-parameter --name "/test/service" --output text --query Parameter.Value > $env_file
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 955746675523.dkr.ecr.ap-southeast-1.amazonaws.com
docker pull $image
docker stop $service
docker rm $service
if [[ $service == "api" ]]
then
  docker run --name $service \
    --env-file $env_file \
    -e SERVICES=$service \
    -e PORT=3000 \
    -p 3000:3000 \
    --restart=unless-stopped \
    -d $image
else
  docker run --name $service \
    --env-file $env_file \
    -e SERVICES=$service \
    --restart=unless-stopped \
    -d $image
fi
while ! docker logs $service | grep -q "started successfully.";
do
    sleep 1
    echo "working..."
done