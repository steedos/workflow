Meteor.publish 'forms', (spaceId)->
	unless this.userId
		return this.ready()

	unless spaceId
		return this.ready()

	console.log '[publish] forms for space ' + spaceId

	return db.forms.find({space: spaceId}, {fields: {name: 1, category: 1, state: 1, description: 1}})


Meteor.publish 'form_version', (spaceId, formId, versionId) ->
	unless this.userId
		return this.ready()

	unless spaceId
		return this.ready()

	unless formId
		return this.ready()

	unless versionId
		return this.ready()

	console.log "[publish] form_version for space:#{spaceId}, formId:#{formId}, versionId: #{versionId} "

	self = this;

	getFormVersion = (id , versionId)->
		form = db.forms.findOne({_id : id});
		form_version = form.current
		if form_version._id != versionId
			form_version = form.historys.findPropertyByPK("_id", versionId)
		console.log "form_version._id: #{form_version._id}"
		return form_version

	handle = db.forms.find({_id: formId}).observeChanges {
		changed: (id)->
			self.changed("form_versions", versionId, getFormVersion(id, versionId));
	}

	self.added("form_versions", versionId, getFormVersion(formId, versionId));
	self.ready();
	self.onStop ()->
		handle.stop()