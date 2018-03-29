db.apps_auths = new Meteor.Collection('apps_auths')

db.apps_auths._simpleSchema = new SimpleSchema
	space: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");

	name: 
		type: String,
		optional: false,
		max: 200,
		autoform: 
			order: 20

	title:
		type: String,
		optional: false,
		max: 200,
		autoform: 
			order: 20
		
	created: 
		type: Date,
		optional: true
	created_by:
		type: String,
		optional: true
	modified:
		type: Date,
		optional: true
	modified_by:
		type: String,
		optional: true
		

if Meteor.isClient
	db.apps_auths._simpleSchema.i18n("apps_auths")

db.apps_auths.attachSchema(db.apps_auths._simpleSchema)



if Meteor.isServer
	
	db.apps_auths.before.insert (userId, doc) ->
		if !userId
			throw new Meteor.Error(400, t("portal_dashboards_error_login_required"));
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, t("portal_dashboards_error_space_not_found"));
		# only space admin can add
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, t("portal_dashboards_error_space_admins_only"));

		doc.created_by = userId
		doc.created = new Date()
		doc.modified_by = userId
		doc.modified = new Date()
		

	db.apps_auths.before.update (userId, doc, fieldNames, modifier, options) ->
		if !userId
			throw new Meteor.Error(400, t("portal_dashboards_error_login_required"));
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, t("portal_dashboards_error_space_not_found"));
		# only space admin can edit
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, t("portal_dashboards_error_space_admins_only"));

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();


	db.apps_auths.before.remove (userId, doc) ->
		if !userId
			throw new Meteor.Error(400, t("portal_dashboards_error_login_required"));
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, t("portal_dashboards_error_space_not_found"));
		# only space admin can remove
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, t("portal_dashboards_error_space_admins_only"));






