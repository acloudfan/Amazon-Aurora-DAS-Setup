# Setup Database Activity Streams on RDS Aurora

### Step-1



### Step-1
Create the CloudFormation Stack 
This would create the resources that we will

export S3BUCKET_TEMPLATE=dasblog-templates2
export S3BUCKET_TEMPLATE_URL=https://dasblog-templates2.s3.amazonaws.com
export CF_TEMPLATE_NAME=das-walkthrough
export DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough


aws cloudformation create-stack \
    --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-main.yml \
    --parameters ParameterKey=TemplateURLBase,ParameterValue=$S3BUCKET_TEMPLATE_URL \
                 ParameterKey=TemplateName,ParameterValue=$CF_TEMPLATE_NAME  \
    --capabilities "CAPABILITY_NAMED_IAM"  --profile blog --region us-east-1



### Step-2
Once the stack has Launched open the Cloud9 IDE

aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME\
                    --query "Stacks[0].Outputs[?OutputKey=='Cloud9URL'].OutputValue" --output text

Copy and paste the URL in a browser tab. We will carry out the rest of the steps in the Cloud9 IDE

### Step-2-2
Setup the environment and download scripts
- Open a terminal
- Setup the environment
Copy thes in a terminal window.

export S3BUCKET_TEMPLATE=dasblog-templates2
export S3BUCKET_TEMPLATE_URL=https://dasblog-templates2.s3.amazonaws.com
export  CF_TEMPLATE_NAME=das-walkthrough
export  DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough

- Copy the content from S3 bucket
aws s3 cp s3://$S3BUCKET_TEMPLATE . --recursive

- Setup the environment
Execute the script 
This script sets up the environment vars in the bashrc file
These are for conveneince
We will be using these env vars in this exercise

chmod 755 ./bin/setup-environment-vars.sh
./bin/setup-environment-vars.sh

### Step-3
By default the DB Activity streams are not enabled. In this step we will enable the DB activity

- Check the status of the DB activity stream
aws rds describe-db-clusters --db-cluster-identifier $DB_CLUSTER_ID   | grep ActivityStreamStatus

- To start the stream
aws rds start-activity-stream \
  --region $AWSREGION \
  --mode async \
  --kms-key-id $DAS_CMK_KEY_ID    \
  --resource-arn  $CLUSTER_ARN \
  --apply-immediately

This command will create the Activity stream in Async mode. Since all data is encrypted we need to pass it the CMK created in our stack. 

The Aurora cluster creates a Kinesis stream to which it writes the database activity records.

- Check the status with the following command. Wait for the stream to get started.
aws rds describe-db-clusters --db-cluster-identifier $DB_CLUSTER_ID   | grep ActivityStreamStatus

You may also check the status of the stream in the RDS console for your cluster under the configuration tab.

Once the stream has started the status will change to "started"
aws rds describe-db-clusters --db-cluster-identifier $DB_CLUSTER_ID   | grep ActivityStream

### Step-4
Create a Firehose deilvery stream to write the records to S3 bucket

export  CF_FIREHOSE_TEMPLATE_NAME="$CF_TEMPLATE_NAME-firehose"
aws cloudformation create-stack \
    --stack-name dasblog-firehose-stream \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-main.yml \
    --parameters ParameterKey=DASS3BucketARN,ParameterValue=$DAS_S3_BUCKET_ARN \
                 ParameterKey=DASStreamARN,ParameterValue=$DAS_STREAM_ARN

--------
aws s3 rm --recursive s3://$DAS_S3_BUCKET
aws s

### For testing stack
export S3BUCKET_TEMPLATE=dasblog-templates2
export S3BUCKET_TEMPLATE_URL=https://dasblog-templates2.s3.amazonaws.com
export CF_TEMPLATE_NAME=das-walkthrough
export DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough


aws cloudformation update-stack \
    --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-main.yml \
    --parameters ParameterKey=TemplateURLBase,ParameterValue=$S3BUCKET_TEMPLATE_URL \
                 ParameterKey=TemplateName,ParameterValue=$CF_TEMPLATE_NAME  \
    --capabilities "CAPABILITY_NAMED_IAM"  --profile blog --region us-east-1


