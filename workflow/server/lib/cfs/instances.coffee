instance_attach_store = new FS.Store.OSS 'instances',
    region: Meteor.settings.cfs.aliyun.region
    internal: Meteor.settings.cfs.aliyun.internal
    bucket: Meteor.settings.cfs.aliyun.bucket
    folder: Meteor.settings.cfs.aliyun.folder
    accessKeyId: Meteor.settings.cfs.aliyun.accessKeyId
    secretAccessKey: Meteor.settings.cfs.aliyun.secretAccessKey



cfs.instances = new FS.Collection "instances",
    stores: [instance_attach_store]

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