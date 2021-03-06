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

(
    echo "Check ECR Repo"
    ecr_repo=$(aws --region ${AWS_Region} ecr describe-repositories) 
    if echo ${ecr_repo} | grep  -q -E ${Repo_Name} 
    then 
	echo "Repo of ${Repo_Name} is existed."
    else
	echo "Create docker image repo"
	aws --region ${AWS_Region} ecr create-repository --repository-name ${Repo_Name}
    fi	
)

(
    #Build docker image
    echo "build image of ${Image_Tag}"
    docker build -t "${Image_Tag}" -f ./Dockerfile .

    #Tag the new docker image to the remote repo
    echo "tag the image"
    #docker tag "${Image_Tag}" "${ECR_URI}/${Image_Tag}:${Image_Ver}"
    docker tag "${Image_Tag}" "${ECR_URI}:${Image_Tag}"

)

(
    # Login to AWS ECR
    echo "longin ecr"
    aws_login=$(aws ecr get-login --no-include-email --region "${AWS_Region}")
    if echo ${aws_login} | grep  -q -E  '^docker login -u AWS -p'
    then 
    	echo "longin ecr"
	$aws_login; 
    fi


    # Push to the remote ECR repo (VERSION identifier)
    echo "push image to ecr"
    docker push "${ECR_URI}:${Image_Tag}"
)


