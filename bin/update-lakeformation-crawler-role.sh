#!/bin/bash

# Check if Lakeformation/Fine grained persmissions are enabled
LF_DETAILS=$(aws lakeformation get-data-lake-settings)
LF_DETAILS_DB=$(echo $LF_DETAILS | jq -r .DataLakeSettings.CreateDatabaseDefaultPermissions[0].Principal.DataLakePrincipalIdentifier)
LF_DETAILS_TABLE=$(echo $LF_DETAILS | jq -r .DataLakeSettings.CreateTableDefaultPermissions[0].Principal.DataLakePrincipalIdentifier)

CALLER_IDENTITY=$(aws sts get-caller-identity | jq -r .Arn)

if [[ "$LF_DETAILS_DB" = "IAM_ALLOWED_PRINCIPALS"  &&  "$LF_DETAILS_TABLE" = "IAM_ALLOWED_PRINCIPALS" ]]; then
  echo "Lakeformation : Finegrained persmissions not enabled"
  echo "No action taken !!!"
  exit 0
else 
  echo "IAM User ($CALLER_IDENTITY) Must have persmissions for Lakeformation"
fi


# Adding Lakeformation permissions
echo "Setting Lake Formation permissions for Webcrawler role"
export DAS_WEBCRAWLER_ROLE=`aws cloudformation --region us-east-1 describe-stacks --stack-name $DAS_WALKTHROUGH_CF_STACK_NAME-aurora-glue   \
                    --query "Stacks[0].Outputs[?OutputKey=='DasblogCrawlerRoleArn'].OutputValue" --output text`
echo $DAS_WEBCRAWLER_ROLE

aws lakeformation grant-permissions --principal DataLakePrincipalIdentifier=$CALLER_IDENTITY --permissions "SELECT" --permissions-with-grant-option "SELECT" --resource '{ "Table": { "DatabaseName": "dasblog-walkthrough-db", "TableWildcard": {} } }'
aws lakeformation grant-permissions --principal DataLakePrincipalIdentifier=$CALLER_IDENTITY  --permissions "ALL" --permissions-with-grant-option "ALL" --resource '{ "Database": { "Name": "dasblog-walkthrough-db"}}'

# Grant select
echo "Granting select permission to current role/IAM user"

aws lakeformation grant-permissions --principal DataLakePrincipalIdentifier=$DAS_WEBCRAWLER_ROLE --permissions "CREATE_DATABASE" --resource '{ "Catalog": {}}' 
aws lakeformation grant-permissions --principal DataLakePrincipalIdentifier=$DAS_WEBCRAWLER_ROLE  --permissions "ALL" --permissions-with-grant-option "ALL" --resource '{ "Database": { "Name": "dasblog-walkthrough-db"}}'
