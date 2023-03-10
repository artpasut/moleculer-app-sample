#!/bin/bash
while getopts i:s:e: flag
do
    case "${flag}" in
        i) image=${OPTARG};;
        s) service=${OPTARG};;
        e) env_file=${OPTARG};;
    esac
done
aws --region=${aws_region} ssm get-parameter --name ${ssm_parameter_name} --output text --query Parameter.Value > $env_file
aws ecr get-login-password --region ${aws_region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com
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