#!/bin/bash

aws athena start-query-execution \
    --query-string "create view my_view as select * from my_table" 
    --result-configuration "OutputLocation=s3://my-bucket/tmp" 
    --query-execution-context "Database=my_database"



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