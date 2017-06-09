db.portal_dashboards = new Meteor.Collection('portal_dashboards')

db.portal_dashboards._simpleSchema = new SimpleSchema
	space: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");

	name: 
		type: String
		optional: false
		max: 200
		autoform: 
			order: 20

	freeboard:
		type: String
		optional: true
		defaultValue: "{}"
		autoform: 
			rows: 20
			omit: true
			type:"hidden"

	description: 
		type: String
		optional: true
		autoform: 
			rows: 10
		
	created: 
		type: Date
		optional: true
		autoform:
			type:"hidden"
	created_by:
		type: String
		optional: true
		autoform:
			type:"hidden"
	modified:
		type: Date
		optional: true
		autoform:
			type:"hidden"
	modified_by:
		type: String
		optional: true
		autoform:
			type:"hidden"
		

if Meteor.isClient
	db.portal_dashboards._simpleSchema.i18n("portal_dashboards")

db.portal_dashboards.attachSchema(db.portal_dashboards._simpleSchema)



if Meteor.isServer
	db.portal_dashboards.allow
		insert: (userId,event) ->
			if userId
				return true
		update: (userId,event) ->
			if userId
				return true
	
	db.portal_dashboards.before.insert (userId, doc) ->
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
		

	db.portal_dashboards.before.update (userId, doc, fieldNames, modifier, options) ->
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


	db.portal_dashboards.before.remove (userId, doc) ->
		if !userId
			throw new Meteor.Error(400, t("portal_dashboards_error_login_required"));
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, t("portal_dashboards_error_space_not_found"));
		# only space admin can remove
		if space.admins.indexOf(userId) < 0
			throw new Meteor.Error(400, t("portal_dashboards_error_space_admins_only"));



