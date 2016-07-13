
# db.raix_push_notifications = new Mongo.Collection('_raix_push_notifications');

# db.raix_push_notifications = Push.notifications

Meteor.publish 'raix_push_notifications', ->

    unless this.userId
        return this.ready()

    appName = "workflow"
    
    query = {query: "{\"userId\":\"" + this.userId + "\",\"appName\":\"" + appName + "\"}"}

    return Push.notifications.find(query, {fields: {createdAt:1, createdBy:1, from:1, title: 1, text:1}})