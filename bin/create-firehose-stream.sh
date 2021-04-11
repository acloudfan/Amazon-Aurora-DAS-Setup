#!/bin/bash

# Check if an argument was passed
if [ -z "$1" ];
   then
        export DO_STREAM_TRANSFORM=No
   else
        if [ "$1" = "yes" ];
        then
                DO_STREAM_TRANSFORM=Yes
        else 
                export DO_STREAM_TRANSFORM=No
        fi
fi

echo "Setting up Firehose Transformation = $DO_STREAM_TRANSFORM"


# 1. Get the ARN of the stream for the DB Cluster
export STREAM_NAME=`aws rds describe-db-clusters  --db-cluster-identifier  $DB_CLUSTER_ID \
        --query 'DBClusters[0].ActivityStreamKinesisStreamName' --output text`

# 2. Get the ARNN of the stream
export DAS_STREAM_ARN=`aws kinesis describe-stream --stream-name $STREAM_NAME --region $AWSREGION \
        --query 'StreamDescription.StreamARN'  --output text`

# 3. Create the stream
export  CF_FIREHOSE_TEMPLATE_NAME="$CF_TEMPLATE_NAME-firehose"
aws cloudformation create-stack \
    --stack-name dasblog-firehose-stream \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-firehose.yml \
    --parameters ParameterKey=TemplateName,ParameterValue=$CF_FIREHOSE_TEMPLATE_NAME \
                 ParameterKey=DASS3BucketTemplate,ParameterValue=$S3BUCKET_TEMPLATE \
                 ParameterKey=DASS3BucketARN,ParameterValue=$DAS_S3_BUCKET_ARN \
                 ParameterKey=DASStreamARN,ParameterValue=$DAS_STREAM_ARN  \
                 ParameterKey=ClusterResourceID,ParameterValue=$CLUSTER_RESOURCE_ID  \
                 ParameterKey=LambdaRoleArn,ParameterValue=$DAS_LAMBDA_ROLE_ARN  \
                 ParameterKey=LambdaFunctionName,ParameterValue=$LAMBDA_FUNCTION_NAME  \
                 ParameterKey=doStreamTransform,ParameterValue=$DO_STREAM_TRANSFORM \
    --capabilities "CAPABILITY_NAMED_IAM"


# # 3. Create the stream
#  aws firehose create-delivery-stream \
#      --delivery-stream-name dasblog-walkthrough-firehose  \
#      --delivery-stream-type KinesisStreamAsSource \
#      --kinesis-stream-source-configuration "KinesisStreamARN=$STREAM_ARN,RoleARN=$DAS_FIREHOSE_ROLE_ARN" \
#      --extended-s3-destination-configuration "BucketARN=$DAS_S3_BUCKET_ARN,RoleARN=$DAS_FIREHOSE_ROLE_ARN,Prefix=success,ErrorOutputPrefix=failed,CloudWatchLoggingOptions={Enabled=true,LogGroupName=dasblog-walkthrough-firehose,LogStreamName=dasblog-walkthrough-logstream}"   
#     #  --delivery-stream-encryption-configuration-input  KeyARN=$DAS_CMK_KEY_ARN,KeyType=CUSTOMER_MANAGED_CMK   


# echo $DAS_STREAM_ARN
# aws cloudformation update-stack \
#     --stack-name dasblog-firehose-stream \
#     --template-body file://dasblog-aurora-firehose.yml \
#     --parameters ParameterKey=DASS3BucketARN,ParameterValue=$DAS_S3_BUCKET_ARN \
#                  ParameterKey=DASStreamARN,ParameterValue=$DAS_STREAM_ARN  \
#                  ParameterKey=ClusterResourceID,ParameterValue=$CLUSTER_RESOURCE_ID  \
#                  ParameterKey=LambdaRoleArn,ParameterValue=$DAS_LAMBDA_ROLE_ARN \
#     --capabilities "CAPABILITY_NAMED_IAM"

