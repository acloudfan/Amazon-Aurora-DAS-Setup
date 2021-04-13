# Setup Database Activity Streams on RDS Aurora

### Step-1



### Step-1
Create the CloudFormation Stack 
This would create the resources that we will

export S3BUCKET_TEMPLATE=dasblog-templates2
export S3BUCKET_TEMPLATE_URL=https://$S3BUCKET_TEMPLATE.s3.amazonaws.com
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

export DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough
aws cloudformation --region us-east-1 describe-stacks \
                   --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME\
                   --query "Stacks[0].Outputs[?OutputKey=='Cloud9URL'].OutputValue" \
                   --output text

Copy and paste the URL in a browser tab. We will carry out the rest of the steps in the Cloud9 IDE

### Step-2-2
Setup the environment and download scripts
- Open a terminal
- Setup the environment
Copy thes in a terminal window.

export S3BUCKET_TEMPLATE=dasblog-templates2
export S3BUCKET_TEMPLATE_URL=https://$S3BUCKET_TEMPLATE.s3.amazonaws.com
export  CF_TEMPLATE_NAME=das-walkthrough
export  DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough

- Copy the content from S3 bucket
aws s3 cp s3://$S3BUCKET_TEMPLATE . --recursive

- Setup the environment
Execute the script 
This script sets up the environment vars in the bashrc file
These are for conveneince
We will be using these env vars in this exercise

chmod u+x ./bin/*
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

./bin/create-firehose-stream.sh

aws cloudformation describe-stacks \
    --stack-name $DAS_WORKSHOP_FIREHOSE_STACK_NAME \
    | grep StackStatus

<!-- export  CF_FIREHOSE_TEMPLATE_NAME="$CF_TEMPLATE_NAME-firehose"
aws cloudformation create-stack \
    --stack-name dasblog-firehose-stream \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-main.yml \
    --parameters ParameterKey=DASS3BucketARN,ParameterValue=$DAS_S3_BUCKET_ARN \
                 ParameterKey=DASStreamARN,ParameterValue=$DAS_STREAM_ARN -->

- Check the records in S3
After a few minutes you would see objects created in the s3 bucket.
The objects will be created in the subfolder "success-xxx" folder orgaznied with the default firehose naming scheme.

### Step-5
Now we will enable the decryption of messages in the Lambda function.

./bin/update-firehose-stream-transform.sh 

If you see messages under "failure-xxx" prefix then taht is because Lambda is unable to decrypt the messages from DAS.

- The role for Lambda need to be added to the CMK Key policy otherwise the Lambda function will not be able to the Key policy for the CMK.

./bin/add-lambda-role-to-cmk-key-policy.sh


- Delete the message in bucket so that we can check the decrypted messages
aws s3 rm --recursive s3://$DAS_S3_BUCKET

Wait for a few minutes and then read the messages from the bucket

Now you would see messages under the prefix "success-xxx" with decrypted event data payload.

### Step-6
Filter the Heartbeat messages

The code in the Lambda function is setup in such a way that it allows the Heartbeat messages to be filtered. This is done by way of an environment variable. Lets go ahead and filter the HB events

aws lambda update-function-configuration   \
       --function-name $LAMBDA_FUNCTION_NAME  \
       --environment Variables="{RESOURCE_ID=$CLUSTER_RESOURCE_ID,FILTER_HEARTBEAT_EVENTS=True}"

Now delete the messages in the older Heartbeat messages from the S3 bucket
aws s3 rm --recursive s3://$DAS_S3_BUCKET

At this time we are ready to check out the events generated by SQL statements !!

- Connect to the test database. This will create a "Connect" event
psql -h $PGHOST -p $PGPORT -U $PGUSER -d $PGDATABASE
- Create a table.
CREATE TABLE test_table(id integer, name varchar(20))
- Insert a row
INSERT INTO test_table(id, name) values(1, 'test');
- Select rows
SELECT * FROM test_table;

### Step-7
Query the data with Athena to generate the reports.

3. setup athena results bucket

1. Create the stack

2. Start the crawler

3. Create the view
-- View Example
CREATE
        OR REPLACE VIEW dasblog AS
SELECT partition_0 AS year,
         partition_1 AS month,
         partition_2 AS day,
         partition_3 AS hour,
         databaseactivityeventlist[1].command AS command,
         databaseactivityeventlist[1].statementid AS statementid,
         databaseactivityeventlist[1].substatementid AS substatementid,
         databaseactivityeventlist[1].objecttype AS objecttype,
         databaseactivityeventlist[1].objectname AS objectname,
         databaseactivityeventlist[1].logtime AS logtime,
         databaseactivityeventlist[1].databasename AS databasename,
         databaseactivityeventlist[1].dbusername AS dbusername,
         databaseactivityeventlist[1].remotehost AS remotehost,
         databaseactivityeventlist[1].remoteport AS remoteport,
         databaseactivityeventlist[1].sessionid AS sessionid,
         databaseactivityeventlist[1].rowcount AS rowcount,
         databaseactivityeventlist[1].commandtext AS commandtext,
         databaseactivityeventlist[1].paramlist AS paramlist,
         databaseactivityeventlist[1].pid AS pid,
         databaseactivityeventlist[1].clientapplication AS clientapplication,
         databaseactivityeventlist[1].exitcode AS exitcode,
         databaseactivityeventlist[1].class AS class,
         databaseactivityeventlist[1].serverversion AS serverversion,
         databaseactivityeventlist[1].servertype AS servertype,
         databaseactivityeventlist[1].servicename AS servicename,
         databaseactivityeventlist[1].serverhost AS serverhost,
         databaseactivityeventlist[1].netprotocol AS netprotocol,
         databaseactivityeventlist[1].dbprotocol AS dbprotocol,
         databaseactivityeventlist[1].type AS type,
         databaseactivityeventlist[1].starttime AS starttime,
         databaseactivityeventlist[1].errormessage AS errormessage,
         databaseactivityeventlist[1] AS raw
FROM das_walkthrough_dasdatabucket_10e42wo0x3ba4 ; 

#### Cleanup
1. Delete the Firehose
aws cloudformation delete-stack --stack-name $DAS_WORKSHOP_FIREHOSE_STACK_NAME
aws cloudformation delete-stack --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME
Delete the Glue Database

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


# Create the lambda package
zip -r9 das-transformer-lambda-python37.zip .

# Create the Lambda Layer
PS: MUST create on a Linux/Ubuntu VM


---- test

aws cloudformation create-stack \
    --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME-aurora-glue \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-glue.yml \
    --parameters ParameterKey=TemplateName,ParameterValue=$CF_TEMPLATE_NAME  \
                 ParameterKey=S3BucketARN,ParameterValue=$DAS_S3_BUCKET_ARN  \
                 ParameterKey=S3BucketPath,ParameterValue=$DAS_S3_BUCKET/  \
    --capabilities "CAPABILITY_NAMED_IAM"  

aws cloudformation update-stack \
    --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME-aurora-glue \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-glue.yml \
    --parameters ParameterKey=TemplateName,ParameterValue=$CF_TEMPLATE_NAME  \
                 ParameterKey=S3BucketARN,ParameterValue=$DAS_S3_BUCKET_ARN  \
                 ParameterKey=S3BucketPath,ParameterValue=$DAS_S3_BUCKET/  \
    --capabilities "CAPABILITY_NAMED_IAM"  

execute the crawler
Name of crawler = $CF_TEMPLATE_NAME-crawler
https://docs.aws.amazon.com/cli/latest/reference/glue/start-crawler.html
https://stackoverflow.com/questions/55386143/aws-glue-tutorial-fails-when-trying-to-run-crawler

aws glue start-crawler --name $CF_TEMPLATE_NAME-crawler
aws glue get-crawler --name $CF_TEMPLATE_NAME-crawler | grep State

