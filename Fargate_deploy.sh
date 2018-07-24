#!/usr/bin/env bash
#
# DESCRIPTION: Fargate Deployment Script
# MAINTAINER: lianghong

set -e

# AWS Region that the ECR located 
AWS_Region='ap-northeast-1'
#AWS account ID
Account_ID="752049529225"

#Fargate cluster name 
Cluster_Name="prediction_cluster"
#Task file with json format
Task_File="prediction-task.json" 
#Service name
Service_Name="prediction"
#AWS Security group
Security_Group=""
#AWS Subnets
Subnets=""

#Repository name 
Repo_Name="my-ecs-repo"
# URI of the ECR
ECR_URI="${Account_ID}.dkr.ecr.${AWS_Region}.amazonaws.com/${Repo_Name}"

#Tag of Docker image
Image_Tag="prediction"
Image_Ver="latest"


aws ecs create-cluster --cluster-name "${Cluster_Name}"
aws ecs register-task-definition --cli-input-json file://"${Task_File}"

aws ecs create-service --cluster "${Cluster_Name}" --service-name "${Service_Name}" --task-definition sample-fargate:1 --desired-count 2 --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-abcd1234],securityGroups=[sg-abcd1234]}"

