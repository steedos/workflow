avatars_store

if Meteor.settings.public.cfs?.store == "OSS"
  if Meteor.isClient
    avatars_store = new FS.Store.OSS("avatars")
  else if Meteor.isServer
    avatars_store = new FS.Store.OSS "avatars",
        region: Meteor.settings.cfs.aliyun.region
        internal: Meteor.settings.cfs.aliyun.internal
        bucket: Meteor.settings.cfs.aliyun.bucket
        folder: Meteor.settings.cfs.aliyun.folder
        accessKeyId: Meteor.settings.cfs.aliyun.accessKeyId
        secretAccessKey: Meteor.settings.cfs.aliyun.secretAccessKey

else if Meteor.settings.public.cfs?.store == "S3"
  if Meteor.isClient
    avatars_store = new FS.Store.S3("avatars")
  else if Meteor.isServer
    avatars_store = new FS.Store.S3 "avatars",
        region: Meteor.settings.cfs.aws.region
        bucket: Meteor.settings.cfs.aws.bucket
        folder: Meteor.settings.cfs.aws.folder
        accessKeyId: Meteor.settings.cfs.aws.accessKeyId
        secretAccessKey: Meteor.settings.cfs.aws.secretAccessKey
else
    avatars_store = new FS.Store.FileSystem("avatars")

db.avatars = new FS.Collection "avatars",  
    stores: [avatars_store]

db.avatars.allow
  insert: ->
    return true;
  update: ->
    return true;
  remove: ->
    return true;
  download: ->
    return true;


db.avatars.files.before.insert((userId, doc) ->
  doc.userId = userId;