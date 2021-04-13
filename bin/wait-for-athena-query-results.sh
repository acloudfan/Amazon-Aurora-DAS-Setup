#!/bin/bash
if [ -z "$1" ]; then
    echo "Please provide the path to you SQL query file !!"
    exit 0
fi

echo $QUERY

DASBLOG_GLUE_TABLE=$(aws athena list-table-metadata \
    --catalog-name AwsDataCatalog \
    --database-name $DASBLOG_GLUE_DATABASE \
    --output json \
    | jq .TableMetadataList[0].Name)

QUERY=$(cat $1)
