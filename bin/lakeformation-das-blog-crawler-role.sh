#!/bin/bash

# Adding Lakeformation permissions
echo "Setting Lake Formation permissions for Webcrawler role"
export DAS_WEBCRAWLER_ROLE=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME-aurora-glue   \
                    --query "Stacks[0].Outputs[?OutputKey=='DasblogCrawlerRoleArn'].OutputValue" --output text`
echo $DAS_WEBCRAWLER_ROLE

aws lakeformation grant-permissions --principal DataLakePrincipalIdentifier=$CALLER_IDENTITY --permissions "SELECT" --permissions-with-grant-option "SELECT" --resource '{ "Table": { "DatabaseName": "dasblog-walkthrough-db", "TableWildcard": {} } }'

# Grant select
echo "Granting select permission to current role/IAM user"
CALLER_IDENTITY=$(aws sts get-caller-identity | jq -r .Arn)
echo $CALLER_IDENTITY
aws lakeformation grant-permissions --principal DataLakePrincipalIdentifier=$DAS_WEBCRAWLER_ROLE --permissions "CREATE_DATABASE" --resource '{ "Catalog": {}}' 
