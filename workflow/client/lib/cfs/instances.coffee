cfs.instances = new FS.Collection "instances",
        stores: [new FS.Store.OSS("instances")]

cfs.instances.allow
        insert: ->
                return true;
        update: ->
                return true;
        remove: ->
                return true;
        download: ->
                return true;