  Meteor.publish 'rocketchat_subscription', ()->
  
    unless this.userId
      return this.ready()
    

    return db.rocketchat_subscription.find({"u._id": this.userId}, {fields: {name: 1, unread:1}})