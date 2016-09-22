  Meteor.publish 'forms', (spaceId)->
  
    unless this.userId
      return this.ready()
    
    unless spaceId
      return this.ready()

    console.log '[publish] forms for space ' + spaceId

    return db.forms.find({space: spaceId}, {fields: {name: 1, category: 1, state:1, is_table_style:1, print_template:1, instance_template:1}})