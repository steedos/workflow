  Meteor.publish 'forms', (spaceId)->
  
    unless this.userId
      return this.ready()
    
    unless spaceId
      return this.ready()

    console.log '[publish] forms for space ' + spaceId

    return db.forms.find({space: spaceId}, {fields: {name: 1, category: 1, state:1}})


  Meteor.publish 'form', (spaceId, formId, versionId) ->
	  unless this.userId
		  return this.ready()

	  unless spaceId
		  return this.ready()

	  unless formId
		  return this.ready()

	  unless versionId
		  return this.ready()

	  console.log "[publish] form for space:#{spaceId}, formId:#{spaceId}, versionId: #{versionId} "

	  form = db.forms.find({_id: formId, "historys._id": versionId}, {fields: {"historys.$": 1, current: 1}})

	  if form.count() < 1
		  form = db.forms.find({_id: formId}, {fields: {current: 1}})

	  return form