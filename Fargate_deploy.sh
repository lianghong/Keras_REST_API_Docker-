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
#ECS task execution role 
Role_File="task-execution-assume-role.json"
#Service name
Service_Name="prediction-service"
#AWS Security group
Security_Group=""
#AWS Subnets
Subnets="subnet-8e6c75a6"
SecurityGroup="sg-4581b83d"

#Repository name 
Repo_Name="my-ecs-repo"
# URI of the ECR
ECR_URI="${Account_ID}.dkr.ecr.${AWS_Region}.amazonaws.com/${Repo_Name}"

#Tag of Docker image
Image_Tag="prediction"
Image_Ver="latest"

#aws ecr describe-images --repository-nam my-ecs-repo --output json | jq  '.imageDetails[0] .registryId'

#create exection role
echo "Create role for task execution"
aws iam --region ${AWS_Region} create-role --role-name ecsTaskExecutionRole --assume-role-policy-document file://${Role_File}
aws iam --region ${AWS_Region} attach-role-policy --role-name ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy


aws ecs create-cluster --cluster-name "${Cluster_Name}"
aws ecs register-task-definition --cli-input-json file://"${Task_File}"

#aws ecs create-service --cli-input-json file://prediction-service.json

aws ecs create-service --cluster "${Cluster_Name}" --service-name "${Service_Name}" --task-definition Prediction --desired-count 1 --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[${Subnets}],securityGroups=[${SecurityGroup}]}"

