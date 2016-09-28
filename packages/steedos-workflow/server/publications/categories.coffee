  Meteor.publish 'categories', (spaceId)->
  
    unless this.userId
      return this.ready()
    
    unless spaceId
      return this.ready()

    console.log '[publish] categories for space ' + spaceId

    return db.categories.find({space: spaceId}, {fields: {name: 1, space: 1}})