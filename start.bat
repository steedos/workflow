set DB_SERVER=192.168.0.21
set MONGO_URL=mongodb://%DB_SERVER%/steedos
set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
set ROOT_URL=http://192.168.0.134:3009/
set METEOR_DOWN_KEY=down_key
set METEOR_PACKAGE_DIRS=C:\Users\dell\Documents\GitHub\creator\packages
set KADIRA_PROFILE_LOCALLY=1
meteor run --settings settings.json --port 3009
