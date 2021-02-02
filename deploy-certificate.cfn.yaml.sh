#!/bin/bash

set -o errexit -o nounset -o pipefail

export AWS_DEFAULT_REGION=us-east-1

aws cloudformation deploy \
  --template-file certificate.cfn.yaml \
  --stack-name uploader-certificate \
  --parameter-override \
    "HostedZoneId=$HOSTED_ZONE_ID" \
    "FrontendDomain=$FRONTEND_DOMAIN" \
    "BackendDomain=$BACKEND_DOMAIN" \
    "SecondDomain=$SECOND_DOMAIN" \
    "AppDomain=$APP_DOMAIN"

certificate=$(aws cloudformation describe-stacks --stack-name uploader-certificate --query 'Stacks[0].Outputs[?OutputKey==`Certificate`].OutputValue' --output text)

echo "::set-output name=certificate::$certificate"
