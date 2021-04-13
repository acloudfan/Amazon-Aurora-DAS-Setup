#!/bin/bash

QUERY="SELECT command, dbusername, databasename, remotehost, clientapplication
FROM $DASBLOG_ATHENA_VIEW_NAME
WHERE (command='CONNECT'
        OR command='DISCONNECT')"

QUERY_ID=$(aws athena start-query-execution  \
  --work-group $DASBLOG_ATHENA_WORKGROUP \
  --query-execution-context "Database=$DASBLOG_GLUE_DATABASE" \
  --query-string "$QUERY"  \
  | jq -r .QueryExecutionId)
  

./bin/run-athena-query.sh  $QUERY_ID
  




