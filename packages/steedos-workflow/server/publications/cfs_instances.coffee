
Meteor.publish 'cfs_instances', (instanceId)->

  unless this.userId
    return this.ready()

  unless instanceId
      return this.ready()

  # console.log '[publish] cfs_instances ' + instanceId

  return cfs.instances.find({'metadata.instance': instanceId})

