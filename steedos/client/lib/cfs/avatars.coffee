avatars_store

if Meteor.settings.public.cfs.store == "OSS"
  avatars_store = new FS.Store.OSS("avatars")
else if Meteor.settings.public.cfs.store == "S3"
  avatars_store = new FS.Store.S3("avatars")

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