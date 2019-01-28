set DB_SERVER=192.168.0.21
set MONGO_URL=mongodb://%DB_SERVER%/steedos
set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
set ROOT_URL=http://192.168.0.134:3009/
set METEOR_DOWN_KEY=down_key
set KADIRA_PROFILE_LOCALLY=1
set TOOL_NODE_FLAGS="--max-old-space-size=1800"
set UNIVERSE_I18N_LOCALES=zh-CN

meteor run --settings settings.json --port 3009
