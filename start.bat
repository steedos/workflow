set DB_SERVER=127.0.0.1
set MONGO_URL=mongodb://%DB_SERVER%/fssh20180410
set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
set ROOT_URL=http://127.0.0.1:3000/
set METEOR_DOWN_KEY=down_key
set KADIRA_PROFILE_LOCALLY=1
set UNIVERSE_I18N_LOCALES=zh-CN
meteor run --settings settings.json