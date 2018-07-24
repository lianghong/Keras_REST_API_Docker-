#!/usr/bin/env bash
#
# DESCRIPTION: ECR Deployment Script
# MAINTAINER: lianghong

set -e

# AWS Region that the ECR located 
AWS_Region='ap-northeast-1'
#AWS account ID
Account_ID="752049529225"
#Repository name 
Repo_Name="my-ecs-repo"
# URI of the ECR
ECR_URI="${Account_ID}.dkr.ecr.${AWS_Region}.amazonaws.com/${Repo_Name}"

#Tag of Docker image
Image_Tag="prediction"
Image_Ver="latest"

(
    #Build docker image
    docker build -t "${Image_Tag}:latest" -f ./Dockerfile .

    #Tag the new docker image to the remote repo
    docker tag "${Image_Tag}:${Image_Ver}" "${ECR_URI}/${Image_Tag}:${Image_Ver}"
)

(
    # Login to AWS ECR
    $(aws ecr get-login --region "${AWS_Region}")

    # Push to the remote ECR repo (VERSION identifier)
    docker push "${ECR_URI}/${Image_Tag}:${Image_Ver}"
)


