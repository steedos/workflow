set DB_SERVER=127.0.0.1
set MONGO_URL=mongodb://%DB_SERVER%/qhd
set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
set ROOT_URL=http://192.168.0.77:3189/
set METEOR_DOWN_KEY=down_key
set METEOR_PACKAGE_DIRS=C:\Users\dell\Documents\GitHub\creator\packages
set KADIRA_PROFILE_LOCALLY=1
meteor run --settings settings.json --port 3189
