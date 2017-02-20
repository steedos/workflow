db.apps_auth_users = new Meteor.Collection('apps_auth_users')

db.apps_auth_users._simpleSchema = new SimpleSchema
	space: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");

	auth_name: 
		type: String,
		optional: false,
		max: 200,
		autoform: 
			omit: false
			type: "select"
			options: ->
				db.apps_auths.find().map (n) ->
					{
						label: n.title
						value: n.name
					}

	user: 
		type: String,
		optional: false,
		max: 200,
		autoform: 
			type: ()->
				# only space admin to show user picker control
				space = db.spaces.findOne(Session.get("spaceId"))
				unless space
					return "hidden"
				user = Meteor.userId()
				if space.admins.indexOf(user) < 0
					return "hidden"
				else
					return "selectuser"
			multiple: false
			defaultValue: ->
				return Meteor.userId()

	user_name: 
		type: String,
		optional: true,
		max: 200,
		autoform: 
			type: "hidden"

	login_name: 
		type: String,
		optional: false,
		max: 200,
		autoform: 
			order: 20

	login_password: 
		type: String,
		optional: false,
		max: 200,
		autoform: 
			type: "password",
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
	db.apps_auth_users._simpleSchema.i18n("apps_auth_users")

db.apps_auth_users.attachSchema(db.apps_auth_users._simpleSchema)



if Meteor.isServer
	
	db.apps_auth_users.before.insert (userId, doc) ->
		if !userId
			throw new Meteor.Error(400, t("portal_dashboards_error_login_required"));
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, t("portal_dashboards_error_space_not_found"));

		doc.user_name = db.users.findOne(doc.user).name

		doc.created_by = userId
		doc.created = new Date()
		doc.modified_by = userId
		doc.modified = new Date()
		

	db.apps_auth_users.before.update (userId, doc, fieldNames, modifier, options) ->
		if !userId
			throw new Meteor.Error(400, t("portal_dashboards_error_login_required"));
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, t("portal_dashboards_error_space_not_found"));

		# only seft can edit
		if space.admins.indexOf(userId) < 0 and userId != doc.user
			throw new Meteor.Error(400, t("apps_auth_users_error_self_edit_only"));

		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();


	db.apps_auth_users.before.remove (userId, doc) ->
		if !userId
			throw new Meteor.Error(400, t("portal_dashboards_error_login_required"));
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, t("portal_dashboards_error_space_not_found"));
		# only seft can remove
		if space.admins.indexOf(userId) < 0 and userId != doc.user
			throw new Meteor.Error(400, t("apps_auth_users_error_self_remove_only"));



