Meteor.publish 'apps_auths', (spaceId)->
  
    unless this.userId
      return this.ready()
    
    unless spaceId
      return this.ready()


    selector = 
        space: spaceId

    return db.apps_auths.find selector, 
        sort: 
            modified: -1
        fields: 
            space: 1
            name: 1
            title: 1
            modified: 1
