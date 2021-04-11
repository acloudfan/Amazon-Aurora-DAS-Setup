# Setup Database Activity Streams on RDS Aurora

### Step-1



### Step-1
Create the CloudFormation Stack 
This would create the resources that we will

S3BUCKET_TEMPLATE_URL=https://dasblog-templates2.s3.amazonaws.com
CF_TEMPLATE_NAME=das-walkthrough
DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough


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

### Step-3
Setup the environment and download scripts
- Open a terminal
- Setup the environment
S3BUCKET_TEMPLATE_URL=https://dasblog-templates2.s3.amazonaws.com
CF_TEMPLATE_NAME=das-walkthrough
DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough

echo "export S3BUCKET_TEMPLATE_URL=\"$S3BUCKET_TEMPLATE_URL\"" >> /home/ec2-user/.bashrc
echo "export CF_TEMPLATE_NAME=\"$CF_TEMPLATE_NAME\"" >> /home/ec2-user/.bashrc
echo "export DAS_WALKTHROUGH_CF_STACK_NAME=\"$DAS_WALKTHROUGH_CF_STACK_NAME\"" >> /home/ec2-user/.bashrc

- Copy the content from S3 bucket
aws s3 cp 



--------
aws s3 rm --recursive s3://$DAS_S3_BUCKET

### For testing stack
S3BUCKET_TEMPLATE_URL=https://dasblog-templates2.s3.amazonaws.com
CF_TEMPLATE_NAME=das-walkthrough
DAS_WALKTHROUGH_CF_STACK_NAME=das-walkthrough


aws cloudformation update-stack \
    --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME \
    --template-url $S3BUCKET_TEMPLATE_URL/cloudformation/dasblog-aurora-main.yml \
    --parameters ParameterKey=TemplateURLBase,ParameterValue=$S3BUCKET_TEMPLATE_URL \
                 ParameterKey=TemplateName,ParameterValue=$CF_TEMPLATE_NAME  \
    --capabilities "CAPABILITY_NAMED_IAM"  --profile blog --region us-east-1


