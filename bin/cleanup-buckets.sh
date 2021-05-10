#!/bin/bash
# Deletes the objects from the buckets created by the CloudFormation
# Used in the cleanup step

ATHENA_RESULT_BUCKET=`aws cloudformation --region $AWSREGION describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME-aurora-glue  \
                    --query "Stacks[0].Outputs[?OutputKey=='AthenaResultQueryBucket'].OutputValue" --output text`

            
echo "Cleaning bucket : $ATHENA_RESULT_BUCKET"

aws s3 rm s3://$ATHENA_RESULT_BUCKET --recursive

echo "Cleaning bucket : $DAS_S3_BUCKET"

aws s3 rm s3://$DAS_S3_BUCKET --recursive