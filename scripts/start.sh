#!/bin/bash

DEPLOY_LOG="/home/ubuntu/app/deploy.log"

# 환경 변수 파일 로드
source /home/ubuntu/app/scripts/env.sh

# 로드된 환경 변수 확인
echo "ECR_REGISTRY: $ECR_REGISTRY" >> $DEPLOY_LOG
echo "ECR_REPOSITORY: $ECR_REPOSITORY" >> $DEPLOY_LOG
echo "IMAGE_TAG: $IMAGE_TAG" >> $DEPLOY_LOG


aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin $ECR_REGISTRY >> $DEPLOY_LOG
docker pull $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG >> $DEPLOY_LOG
docker run -p 8080:8080 -e PROFILE=dev -d --restart always --name zzin_quiz_spring $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG >> $DEPLOY_LOG
docker image prune -f >> $DEPLOY_LOG
