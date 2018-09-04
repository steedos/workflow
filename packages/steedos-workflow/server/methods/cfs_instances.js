Meteor.methods({
    cfs_instances_remove: function (file_id) {
        check(file_id, String);
        cfs.instances.remove(file_id);
        return true;
    },

    cfs_instances_set_current: function (file_id) {
        check(file_id, String);
        cfs.instances.update({
            _id: file_id
        }, {
            $set: {
                'metadata.current': true
            }
        });
        return true;
    },

    cfs_instances_lock: function (file_id, user_id, user_name) {
        cfs.instances.update({
            _id: file_id
        }, {
            $set: {
                'metadata.locked_by': user_id,
                'metadata.locked_by_name': user_name,
                'metadata.locked_time': new Date()
            }
        });
        return true;
    },

    cfs_instances_unlock: function (file_id) {
        cfs.instances.update({
            _id: file_id
        }, {
            $unset: {
                'metadata.locked_by': '',
                'metadata.locked_by_name': '',
                'metadata.locked_time': ''
            }
        });
        return true;
    },

    download_space_instance_attachments_to_disk: function (spaceId) {
        check(spaceId, String);

        var store = "instances";
        var fs = Npm.require('fs');
        var path = Npm.require('path');
        var mkdirp = Npm.require('mkdirp');
        var pathname = path.join(__meteor_bootstrap__.serverDir, '../../../cfs/spaceInstanceAttachments');
        // Set absolute path
        var absolutePath = path.resolve(pathname);
        // Ensure the path exists
        mkdirp.sync(absolutePath);
        console.log('absolutePath: ', absolutePath);
        cfs.instances.find({
            'metadata.space': spaceId
        }).forEach(function (c) {
            var fileName = store + '-' + c._id + '-' + c.name();
            var filePath = path.join(absolutePath, fileName);
            console.log('filePath: ', filePath);
            c.createReadStream(store).pipe(fs.createWriteStream(filePath));
        })
    }
})