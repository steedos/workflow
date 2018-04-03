set DB_SERVER=192.168.0.23
set MONGO_URL=mongodb://%DB_SERVER%/qhd201711091030
set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
set ROOT_URL=http://192.168.0.134:3004/
meteor run --settings settings.json --port 3004
