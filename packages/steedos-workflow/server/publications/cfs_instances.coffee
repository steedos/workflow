
Meteor.publish 'cfs_instances', (instanceId)->

  unless this.userId
    return this.ready()

  unless instanceId
      return this.ready()


  return cfs.instances.find({'metadata.instance': instanceId, $or: [{'metadata.is_private': {$ne: true}},{'metadata.is_private': true, "metadata.owner": this.userId}]})

