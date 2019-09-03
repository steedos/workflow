REM set DB_SERVER=192.168.0.23
REM set DB_SERVER=192.168.0.21
set DB_SERVER=192.168.0.195
REM set MONGO_URL=mongodb://%DB_SERVER%/steedos
REM set MONGO_URL=mongodb://%DB_SERVER%/fssh20180410
REM set MONGO_URL=mongodb://%DB_SERVER%/fssh20181214
REM set MONGO_URL=mongodb://%DB_SERVER%/qhd20180810
REM set MONGO_URL=mongodb://%DB_SERVER%/fssh
set MONGO_URL=mongodb://%DB_SERVER%/qhd-beta
REM set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
set ROOT_URL=http://192.168.0.195:3198/
set METEOR_DOWN_KEY=down_key
set METEOR_PACKAGE_DIRS=D:\meteor_temp_pgs\packages
set KADIRA_PROFILE_LOCALLY=1
REM set mail_URL=smtps://AKIAITDNQGTJ3QNISIHQ:AqOYSssTK8bS5TwnAIK4RNQyl2CSaxOxXFIktypJ%2BZZP@email-smtp.us-east-1.amazonaws.com:465/
set MAIL_URL=smtps://AKIAITDNQGTJ3QNISIHQ:AqOYSssTK8bS5TwnAIK4RNQyl2CSaxOxXFIktypJ%%2BZZP@email-smtp.us-east-1.amazonaws.com:465/
set UNIVERSE_I18N_LOCALES=zh-CN
set TOOL_NODE_FLAGS="--max-old-space-size=1800"
REM set METEOR_PROFILE=100

meteor run --settings settings.json --port 3198
