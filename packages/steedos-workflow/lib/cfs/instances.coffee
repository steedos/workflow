fs_store

if Meteor.settings.public.cfs?.store == "OSS"
    if Meteor.isClient
        fs_store = new FS.Store.OSS('instances')
    else if Meteor.isServer
        fs_store = new FS.Store.OSS 'instances',
            region: Meteor.settings.cfs.aliyun.region
            internal: Meteor.settings.cfs.aliyun.internal
            bucket: Meteor.settings.cfs.aliyun.bucket
            folder: Meteor.settings.cfs.aliyun.folder
            accessKeyId: Meteor.settings.cfs.aliyun.accessKeyId
            secretAccessKey: Meteor.settings.cfs.aliyun.secretAccessKey

else if Meteor.settings.public.cfs?.store == "S3"
    if Meteor.isClient
        fs_store = new FS.Store.S3("instances")
    else if Meteor.isServer
        fs_store = new FS.Store.S3 "instances",
            region: Meteor.settings.cfs.aws.region
            bucket: Meteor.settings.cfs.aws.bucket
            folder: Meteor.settings.cfs.aws.folder
            accessKeyId: Meteor.settings.cfs.aws.accessKeyId
            secretAccessKey: Meteor.settings.cfs.aws.secretAccessKey
else
    fs_store = new FS.Store.FileSystem("instances")

cfs.instances = new FS.Collection "instances",
    stores: [fs_store]

cfs.instances.allow
    insert: ->
            return true;
    update: ->
            return true;
    remove: ->
            return true;
    download: ->
                return true;

if Meteor.isServer
        Meteor.startup ->
                cfs.instances.files._ensureIndex({"metadata.instance": 1})
                cfs.instances.files._ensureIndex({"failures.copies.instances.doneTrying": 1})
                cfs.instances.files._ensureIndex({"copies.instances": 1})
                cfs.instances.files._ensureIndex({"uploadedAt": 1})                