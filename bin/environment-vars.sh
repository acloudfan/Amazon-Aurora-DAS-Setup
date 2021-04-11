#!/bin/bash

# Setup the AWS Region
export AWSREGION=`aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'`

# CMK used for data encryption
export DAS_CMK_KEY_ID=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DASCMKKeyID'].OutputValue" --output text`

export DAS_CMK_KEY_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DASCMKKeyArn'].OutputValue" --output text`

export DAS_LAMBDA_ROLE_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DASLambdaRoleArn'].OutputValue" --output text`

export DAS_S3_BUCKET=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DASS3Bucket'].OutputValue" --output text`

export DAS_S3_BUCKET_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DASS3BucketArn'].OutputValue" --output text`

# export DAS_FIREHOSE_ROLE_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
#                     --query "Stacks[0].Outputs[?OutputKey=='DASFirehoseS3RoleArn'].OutputValue" --output text`

export DB_SECURITY_GROUP=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DBSecGroup'].OutputValue" --output text`

export DB_USER_NAME=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DBUsername'].OutputValue" --output text`

export DB_NAME=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DatabaseName'].OutputValue" --output text`

export DB_PORT=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='Port'].OutputValue" --output text`

export WALKTHROUGH_VPC=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='WalkthroughVPC'].OutputValue" --output text`

export RDS_CLUSTER_ENDPOINT=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='clusterEndpoint'].OutputValue" --output text`

export RDS_READER_ENDPOINT=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='readerEndpoint'].OutputValue" --output text`

export DB_SECRET_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='secretArn'].OutputValue" --output text`

export DB_CLUSTER_ID=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \
                    --query "Stacks[0].Outputs[?OutputKey=='DBClusterId'].OutputValue" --output text`


export CLUSTER_RESOURCE_ID=`aws rds describe-db-clusters  --db-cluster-identifier  $DB_CLUSTER_ID \
        --query 'DBClusters[0].DbClusterResourceId' --output text`

export CLUSTER_ARN=`aws rds describe-db-clusters  --db-cluster-identifier  $DB_CLUSTER_ID \
        --query 'DBClusters[0].DBClusterArn' --output text`


