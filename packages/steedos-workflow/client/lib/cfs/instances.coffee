fs_store

if Meteor.settings.public.cfs.store == "OSS"
  fs_store = new FS.Store.OSS("instances")
else if Meteor.settings.public.cfs.store == "S3"
  fs_store = new FS.Store.S3("instances")

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