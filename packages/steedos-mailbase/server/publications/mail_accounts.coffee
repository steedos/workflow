  Meteor.publish 'mail_accounts', ()->
  
    unless this.userId
      return this.ready()
    
    console.log '[publish] mail_accounts for user ' + this.userId

    return db.mail_accounts.find({owner: this.userId})