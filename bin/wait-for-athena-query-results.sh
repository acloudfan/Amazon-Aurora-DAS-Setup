#!/bin/bash

QUERY_ID=$1

STATE="RUNNING"

while [ "$STATE" = "RUNNING" ]
do
    STATE=$(aws athena get-query-execution \
                    --query-execution-id  $QUERY_ID \
                    | jq -r .QueryExecution.Status.State )
                    
    echo "$STATE"
done

# Exit if there is a failure
if [ "$STATE" == "FAILED" ];
then 
    aws athena get-query-execution \
            --query-execution-id  $QUERY_ID
            
    exit 1
fi

# Read the data from the result bucket if query was successful
if [ "$STATE" == "SUCCEEDED" ];
then
    RESULT_LOCATION=$(aws athena get-query-execution \
                        --query-execution-id  $QUERY_ID   \
                        | jq -r .QueryExecution.ResultConfiguration.OutputLocation)
                        
    echo "Query Result Location: $RESULT_LOCATION"
    
    echo "Content"
    echo "======"
    
    aws s3 cp $RESULT_LOCATION  /dev/stdout
fi

   

