Template.webMailAccount.helpers

	schema: ->
		return db.mail_accounts._simpleSchema;

	doc: ->
		return db.mail_accounts.findOne({owner: Meteor.userId()})

	type: ->
		if db.mail_accounts.findOne({owner: Meteor.userId()})
			return "update";
		return "insert";

	btn_submit_i18n: ->
		return TAPi18n.__ 'OK'

Template.webMailAccount.onRendered ->
	$("body").removeClass("loading")
