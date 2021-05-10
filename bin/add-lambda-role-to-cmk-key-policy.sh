#!/bin/sh

# Script is executed for setting up the permissions for Lambda Role
# Lambda role must have access to the CMK for decrypting the events data

ADD_ON='{\n \"Sid\" : \"Enable lambda role to access key\",\n \"Effect\" : \"Allow\",\n \"Principal\" : {\n \"AWS\" : \"'$DAS_LAMBDA_ROLE_ARN'\"\n },\n \"Action\" : \"kms:*\",\n \"Resource\" : \"*\"\n }'

ADD_ON_JSON='{ "Sid" : "Enable lambda role to access key","Effect" : "Allow","Principal" : { "AWS" : "'$DAS_LAMBDA_ROLE_ARN'" }, "Action" : "kms:*", "Resource" : "*" }'

POLICY=`aws kms get-key-policy --key-id $DAS_CMK_KEY_ARN --policy-name default --output json`

POLICY=$( jq -r '.Policy' <<< "$POLICY")

PART1=$(echo $POLICY | cut -f1 -d])
PART2=$(echo $POLICY | cut -f2 -d])
NEW_POLICY="$PART1 , $ADD_ON_JSON ]  $PART2"

# Put together a key policy in a file that is then used for adding the policy to Lamda role
mkdir temp
echo $NEW_POLICY > temp/key-policy.json

# Put the key policy
aws kms put-key-policy \
    --key-id $DAS_CMK_KEY_ARN \
    --policy-name default \
    --policy  file://temp/key-policy.json

aws kms get-key-policy \
    --policy-name default \
    --key-id $DAS_CMK_KEY_ARN 

rm -r ./temp
