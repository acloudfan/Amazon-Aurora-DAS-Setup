#!/bin/bash
#This script does 3 things:
# 1. Installs the psql used for testing
# 2. Installs jq for parsing of JSON on command line
# 3. Updates the bashrc file with environment variables that are used in scripts and commands
# This script needs to be executed only once

# install psql
echo "Installing psql ..."
sudo yum install -y postgresql96-contrib 

# install jq
echo "Installing jq ..."
sudo yum install -y jq

echo "Setting up environment variables ... please wait"

# These 4 variables MUST be setup before executing the rest of the script

echo "export S3BUCKET_TEMPLATE_URL=\"$S3BUCKET_TEMPLATE_URL\"" >> /home/ec2-user/.bashrc
echo "export CF_TEMPLATE_NAME=\"$CF_TEMPLATE_NAME\"" >> /home/ec2-user/.bashrc
echo "export DAS_WALKTHROUGH_CF_STACK_NAME=\"$DAS_WALKTHROUGH_CF_STACK_NAME\"" >> /home/ec2-user/.bashrc
echo "export S3BUCKET_TEMPLATE=\"$S3BUCKET_TEMPLATE\"" >> /home/ec2-user/.bashrc



# Setup the AWS Region
export AWSREGION=`aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'`
echo "export AWSREGION=\"$AWSREGION\"" >> /home/ec2-user/.bashrc

# CMK used for data encryption
export DAS_CMK_KEY_ID=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DASCMKKeyID'].OutputValue" --output text`
echo "export DAS_CMK_KEY_ID=\"$DAS_CMK_KEY_ID\"" >> /home/ec2-user/.bashrc

export DAS_CMK_KEY_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DASCMKKeyArn'].OutputValue" --output text`
echo "export DAS_CMK_KEY_ARN=\"$DAS_CMK_KEY_ARN\"" >> /home/ec2-user/.bashrc

export DAS_LAMBDA_ROLE_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DASLambdaRoleArn'].OutputValue" --output text`
echo "export DAS_LAMBDA_ROLE_ARN=\"$DAS_LAMBDA_ROLE_ARN\"" >> /home/ec2-user/.bashrc

export DAS_S3_BUCKET=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DASS3Bucket'].OutputValue" --output text`
echo "export DAS_S3_BUCKET=\"$DAS_S3_BUCKET\"" >> /home/ec2-user/.bashrc

export DAS_S3_BUCKET_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DASS3BucketArn'].OutputValue" --output text`
echo "export DAS_S3_BUCKET_ARN=\"$DAS_S3_BUCKET_ARN\"" >> /home/ec2-user/.bashrc

export DB_SECURITY_GROUP=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DBSecGroup'].OutputValue" --output text`
echo "export DB_SECURITY_GROUP=\"$DB_SECURITY_GROUP\"" >> /home/ec2-user/.bashrc

export DB_USER_NAME=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DBUsername'].OutputValue" --output text`
echo "export DB_USER_NAME=\"$DB_USER_NAME\"" >> /home/ec2-user/.bashrc

export DB_NAME=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DatabaseName'].OutputValue" --output text`
echo "export DB_NAME=\"$DB_NAME\"" >> /home/ec2-user/.bashrc

export DB_PORT=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='Port'].OutputValue" --output text`
echo "export DB_PORT=\"$DB_PORT\"" >> /home/ec2-user/.bashrc

export WALKTHROUGH_VPC=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='WalkthroughVPC'].OutputValue" --output text`
echo "export WALKTHROUGH_VPC=\"$WALKTHROUGH_VPC\"" >> /home/ec2-user/.bashrc

export RDS_CLUSTER_ENDPOINT=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='clusterEndpoint'].OutputValue" --output text`
echo "export RDS_CLUSTER_ENDPOINT=\"$RDS_CLUSTER_ENDPOINT\"" >> /home/ec2-user/.bashrc

export RDS_READER_ENDPOINT=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='readerEndpoint'].OutputValue" --output text`
echo "export RDS_READER_ENDPOINT=\"$RDS_READER_ENDPOINT\"" >> /home/ec2-user/.bashrc

export DB_SECRET_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='secretArn'].OutputValue" --output text`
echo "export DB_SECRET_ARN=\"$DB_SECRET_ARN\"" >> /home/ec2-user/.bashrc

export DB_CLUSTER_ID=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME  \
                    --query "Stacks[0].Outputs[?OutputKey=='DBClusterId'].OutputValue" --output text`
echo "export DB_CLUSTER_ID=\"$DB_CLUSTER_ID\"" >> /home/ec2-user/.bashrc

export CLUSTER_RESOURCE_ID=`aws rds describe-db-clusters  --db-cluster-identifier  $DB_CLUSTER_ID \
        --query 'DBClusters[0].DbClusterResourceId' --output text`
echo "export CLUSTER_RESOURCE_ID=\"$CLUSTER_RESOURCE_ID\"" >> /home/ec2-user/.bashrc

export CLUSTER_ARN=`aws rds describe-db-clusters  --db-cluster-identifier  $DB_CLUSTER_ID \
        --query 'DBClusters[0].DBClusterArn' --output text`
echo "export CLUSTER_ARN=\"$CLUSTER_ARN\"" >> /home/ec2-user/.bashrc

# Firehose stack name
export DAS_WORKSHOP_FIREHOSE_STACK_NAME=dasblog-firehose-stream
echo "export DAS_WORKSHOP_FIREHOSE_STACK_NAME=\"$DAS_WORKSHOP_FIREHOSE_STACK_NAME\"" >> /home/ec2-user/.bashrc

# Lambda function name
export LAMBDA_FUNCTION_NAME=das-stream-firehose-transformer
echo "export LAMBDA_FUNCTION_NAME=\"$LAMBDA_FUNCTION_NAME\"" >> /home/ec2-user/.bashrc

# setup DB parameters for psql
CREDS=`aws secretsmanager get-secret-value --secret-id $DB_SECRET_ARN  --region $AWSREGION | jq -r '.SecretString'`
export DBUSER="`echo $CREDS | jq -r '.username'`"
export DBPASS="`echo $CREDS | jq -r '.password'`"

export PGHOST=$DBENDP
export PGUSER=$DBUSER
export PGPASSWORD="$DBPASS"
export PGDATABASE=$DB_NAME

echo "export DBPASS=\"$DBPASS\"" >> /home/ec2-user/.bashrc
echo "export DBUSER=$DBUSER" >> /home/ec2-user/.bashrc
echo "export DBENDP=$DBENDP" >> /home/ec2-user/.bashrc
echo "export PGUSER=$DBUSER" >> /home/ec2-user/.bashrc
echo "export PGPASSWORD=\"$DBPASS\"" >> /home/ec2-user/.bashrc
echo "export PGHOST=$RDS_CLUSTER_ENDPOINT" >> /home/ec2-user/.bashrc
echo "export PGPORT=$DB_PORT" >> /home/ec2-user/.bashrc
echo "export PGDATABASE=$DB_NAME" >> /home/ec2-user/.bashrc


# Glue & Athena
export DASBLOG_GLUE_DATABASE=dasblog-walkthrough-db
export DASBLOG_ATHENA_WORKGROUP=dasblog-workgroup
export DASBLOG_ATHENA_VIEW_NAME=dasblog

echo "export DASBLOG_GLUE_DATABASE=\"$DASBLOG_GLUE_DATABASE\"" >> /home/ec2-user/.bashrc
echo "export DASBLOG_ATHENA_WORKGROUP=\"$DASBLOG_ATHENA_WORKGROUP\"" >> /home/ec2-user/.bashrc
echo "export DASBLOG_ATHENA_VIEW_NAME=\"$DASBLOG_ATHENA_VIEW_NAME\"" >> /home/ec2-user/.bashrc

echo "Done."