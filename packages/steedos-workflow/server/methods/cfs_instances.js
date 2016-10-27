Meteor.methods({
    cfs_instances_remove: function(file_id) {
        check(file_id, String);
        cfs.instances.remove(file_id);
        return true;
    },

    cfs_instances_set_current: function(file_id) {
        check(file_id, String);
        cfs.instances.update({
            _id: file_id
        }, {
            $set: {
                'metadata.current': true
            }
        });
        return true;
    }
})