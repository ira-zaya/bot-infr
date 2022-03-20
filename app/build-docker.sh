#!/bin/bash
echo "REGION = eu-west-2"
echo "URL:TAG = hello-dev:v1"
echo "Login AWS_ECR using Docker:"
echo ""
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 581835478100.dkr.ecr.eu-west-2.amazonaws.com

echo "Build Docker Container:"
echo ""
docker build -t hello-dev:v1 .

echo "Tag Docker Container:"
echo ""
docker tag hello-dev:v1 581835478100.dkr.ecr.eu-west-2.amazonaws.com/hello-dev:v1

echo "Push to AWS_ECR:"
echo ""
docker push 581835478100.dkr.ecr.eu-west-2.amazonaws.com/hello-dev:v1

