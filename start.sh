export DB_SERVER=192.168.0.23

export MONGO_URL="mongodb://$DB_SERVER/steedos"
export MONGO_OPLOG_URL="mongodb://$DB_SERVER/local"
export MULTIPLE_INSTANCES_COLLECTION_NAME=workflow_instances
export ROOT_URL=http://192.168.0.196:3000/
meteor run --settings settings.json
