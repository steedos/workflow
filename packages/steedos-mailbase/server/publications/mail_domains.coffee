Meteor.publish 'mail_domains', ()->
  
    return db.mail_domains.find()