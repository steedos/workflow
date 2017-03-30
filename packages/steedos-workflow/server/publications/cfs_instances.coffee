
Meteor.publish 'cfs_instances', (instanceId)->

  unless this.userId
    return this.ready()

  unless instanceId
      return this.ready()


  return cfs.instances.find({'metadata.instance': instanceId})

