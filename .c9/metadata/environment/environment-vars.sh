{"filter":false,"title":"environment-vars.sh","tooltip":"/environment-vars.sh","undoManager":{"mark":8,"position":8,"stack":[[{"start":{"row":0,"column":0},"end":{"row":56,"column":59},"action":"insert","lines":["","","# Setup the AWS Region","export AWSREGION=`aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]'`","","# CMK used for data encryption","export DAS_CMK_KEY_ID=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DASCMKKeyID'].OutputValue\" --output text`","","export DAS_CMK_KEY_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DASCMKKeyArn'].OutputValue\" --output text`","","export DAS_LAMBDA_ROLE_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DASLambdaRoleArn'].OutputValue\" --output text`","","export DAS_S3_BUCKET=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DASS3Bucket'].OutputValue\" --output text`","","export DAS_S3_BUCKET_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DASS3BucketArn'].OutputValue\" --output text`","","# export DAS_FIREHOSE_ROLE_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","#                     --query \"Stacks[0].Outputs[?OutputKey=='DASFirehoseS3RoleArn'].OutputValue\" --output text`","","export DB_SECURITY_GROUP=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DBSecGroup'].OutputValue\" --output text`","","export DB_USER_NAME=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DBUsername'].OutputValue\" --output text`","","export DB_NAME=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DatabaseName'].OutputValue\" --output text`","","export DB_PORT=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='Port'].OutputValue\" --output text`","","export WALKTHROUGH_VPC=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='WalkthroughVPC'].OutputValue\" --output text`","","export RDS_CLUSTER_ENDPOINT=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='clusterEndpoint'].OutputValue\" --output text`","","export RDS_READER_ENDPOINT=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='readerEndpoint'].OutputValue\" --output text`","","export DB_SECRET_ARN=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='secretArn'].OutputValue\" --output text`","","export DB_CLUSTER_ID=`aws cloudformation --region us-east-1 describe-stacks --stack-name dasblog-test \\","                    --query \"Stacks[0].Outputs[?OutputKey=='DBClusterId'].OutputValue\" --output text`","","","export CLUSTER_RESOURCE_ID=`aws rds describe-db-clusters  --db-cluster-identifier  $DB_CLUSTER_ID \\","        --query 'DBClusters[0].DbClusterResourceId' --output text`","","export CLUSTER_ARN=`aws rds describe-db-clusters  --db-cluster-identifier  $DB_CLUSTER_ID \\","        --query 'DBClusters[0].DBClusterArn' --output text`"],"id":1}],[{"start":{"row":0,"column":0},"end":{"row":0,"column":1},"action":"insert","lines":["#"],"id":2},{"start":{"row":0,"column":1},"end":{"row":0,"column":2},"action":"insert","lines":["!"]},{"start":{"row":0,"column":2},"end":{"row":0,"column":3},"action":"insert","lines":["/"]}],[{"start":{"row":0,"column":3},"end":{"row":0,"column":4},"action":"insert","lines":["b"],"id":3},{"start":{"row":0,"column":4},"end":{"row":0,"column":5},"action":"insert","lines":["i"]},{"start":{"row":0,"column":5},"end":{"row":0,"column":6},"action":"insert","lines":["n"]},{"start":{"row":0,"column":6},"end":{"row":0,"column":7},"action":"insert","lines":["/"]}],[{"start":{"row":0,"column":7},"end":{"row":0,"column":8},"action":"insert","lines":["s"],"id":4},{"start":{"row":0,"column":8},"end":{"row":0,"column":9},"action":"insert","lines":["h"]}],[{"start":{"row":56,"column":59},"end":{"row":57,"column":0},"action":"insert","lines":["",""],"id":5},{"start":{"row":57,"column":0},"end":{"row":57,"column":8},"action":"insert","lines":["        "]}],[{"start":{"row":57,"column":4},"end":{"row":57,"column":8},"action":"remove","lines":["    "],"id":6},{"start":{"row":57,"column":0},"end":{"row":57,"column":4},"action":"remove","lines":["    "]}],[{"start":{"row":57,"column":0},"end":{"row":58,"column":0},"action":"insert","lines":["",""],"id":7},{"start":{"row":58,"column":0},"end":{"row":59,"column":0},"action":"insert","lines":["",""]}],[{"start":{"row":0,"column":8},"end":{"row":0,"column":9},"action":"remove","lines":["h"],"id":8},{"start":{"row":0,"column":7},"end":{"row":0,"column":8},"action":"remove","lines":["s"]}],[{"start":{"row":0,"column":7},"end":{"row":0,"column":8},"action":"insert","lines":["b"],"id":9},{"start":{"row":0,"column":8},"end":{"row":0,"column":9},"action":"insert","lines":["a"]},{"start":{"row":0,"column":9},"end":{"row":0,"column":10},"action":"insert","lines":["s"]},{"start":{"row":0,"column":10},"end":{"row":0,"column":11},"action":"insert","lines":["h"]}]]},"ace":{"folds":[],"scrolltop":0,"scrollleft":0,"selection":{"start":{"row":12,"column":7},"end":{"row":12,"column":26},"isBackwards":true},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":0},"timestamp":1618067864620,"hash":"36928fa5ab7f9455732670c1a0cca779dc5368e5"}