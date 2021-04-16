#!/bin/bash

QUERY="SELECT command, dbusername, databasename, remotehost, clientapplication
FROM $DASBLOG_ATHENA_VIEW_NAME
WHERE (command='INSERT')"


#----- Do not change under this line ----#

# Start the execution of the Query
QUERY_ID=$(aws athena start-query-execution  \
  --work-group $DASBLOG_ATHENA_WORKGROUP \
  --query-execution-context "Database=$DASBLOG_GLUE_DATABASE" \
  --query-string "$QUERY"  \
  | jq -r .QueryExecutionId)
  
echo "QUERY_ID=$QUERY_ID"

# Call to this will make the execution wait for the query to complete
# Once the query has completed, results will be dumped on the console
if [ -n "$QUERY_ID" ];
then
    ./bin/wait-for-athena-query-results.sh  $QUERY_ID
else
    echo "Error in Query?"
fi
  