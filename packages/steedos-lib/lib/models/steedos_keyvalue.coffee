db.steedos_keyvalues = new Meteor.Collection('steedos_keyvalues')

db.steedos_keyvalues._simpleSchema = new SimpleSchema
  
  # 工作区
  space:
    type: String
  # user_id
  user:
    type: String
  # key
  key:
    type: String
  # 
  value:
    type: Object
    blackbox: true


if Meteor.isServer
  
  Meteor.publish 'steedos_keyvalues', ()->
    
    unless this.userId
      return this.ready()

    selector = 
      user: this.userId

    console.log '[publish] steedos_keyvalues ' + this.userId

    return db.steedos_keyvalues.find(selector)

