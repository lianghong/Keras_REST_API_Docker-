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


aws ecs update-service --cluster ${Cluster_Name} --service ${Service_Name} --desired-count 0 --region ${AWS_Region}

aws ecs delete-service --cluster ${Cluster_Name} --service ${Service_Name} --region ${AWS_Region}

aws ecs deregister-container-instance --cluster ${Cluster_Name} --container-instance container_instance_id --region ${AWS_Region} --force


