#!/bin/bash

set -o errexit -o nounset -o pipefail

export AWS_DEFAULT_REGION=ap-southeast-2

aws cloudformation deploy \
  --template-file deployment.cfn.yaml \
  --stack-name uploader \
  --parameter-override \
    "HostedZoneId=$HOSTED_ZONE_ID" \
    "AppDomain=$APP_DOMAIN" \
    "FrontendWebsiteCertificate=$FRONTEND_WEBSITE_CERTIFICATE" \
    "BackendJWTAudience=$BACKEND_JWT_AUDIENCE" \
    "BackendLambdaS3Bucket=$BACKEND_LAMBDA_S3_BUCKET" \
    "BackendLambdaS3Key=$BACKEND_LAMBDA_S3_KEY" \
    "BackendJWTPrivateKey=$BACKEND_JWT_PRIVATE_KEY" \
    "VeypearPresenterBase=$VEYPEAR_PRESENTER_BASE" \
  --capabilities CAPABILITY_IAM

FRONTEND_BUCKET=$(aws cloudformation describe-stacks --stack-name uploader --query 'Stacks[0].Outputs[?OutputKey==`FrontendWebsiteBucket`].OutputValue' --output text)

echo "::set-output name=frontendBucket::$FRONTEND_BUCKET"
