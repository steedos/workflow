db.space_users = new Meteor.Collection('space_users')

db.space_users._simpleSchema = new SimpleSchema
	space:
		type: String,
		autoform:
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name:
		type: String,
		max: 50,
	email:
		type: String,
		regEx: SimpleSchema.RegEx.Email,
		optional: true
		autoform:
			type: "hidden"
	user:
		type: String,
		optional: true,
		autoform:
			omit: true

	organization:
		type: String,
		optional: true,
		autoform:
			omit: true

	organizations:
		type: [String],
		autoform:
			type: "selectorg"
			multiple: true
			defaultValue: ->
				return []

	manager:
		type: String,
		optional: true,
		autoform:
			type: "selectuser"

	sort_no:
		type: Number,
		optional: true

	user_accepted:
		type: Boolean,
		optional: true,
		autoform:
			defaultValue: true

	created:
		type: Date,
		optional: true
		autoform:
			omit: true
	created_by:
		type: String,
		optional: true
		autoform:
			omit: true
	modified:
		type: Date,
		optional: true
		autoform:
			omit: true
	modified_by:
		type: String,
		optional: true
		autoform:
			omit: true
	mobile: 
		type: String,
		optional: true


if Meteor.isClient
	db.space_users._simpleSchema.i18n("space_users")
	db.space_users._sortFunction = (doc1, doc2) ->
		if (doc1.sort_no == doc2.sort_no)
			return doc1.name?.localeCompare(doc2.name)
		else if (doc1.sort_no is undefined)
			return 1
		else if (doc2.sort_no is undefined)
			return -1
		else if (doc1.sort_no > doc2.sort_no)
			return -1
		else
			return 1

	db.space_users.before.find (userId, query, options)->
		if !options
			options = {}
		options.sort = db.space_users._sortFunction


db.space_users.attachSchema(db.space_users._simpleSchema);


db.space_users.helpers
	space_name: ->
		space = db.spaces.findOne({_id: this.space});
		return space?.name
	organization_name: ->
		if this.organizations
			organizations = SteedosDataManager.organizationRemote.find({_id: {$in: this.organizations}}, {fields: {fullname: 1}})
			return organizations?.getProperty('fullname').join('<br/>')
		return

if (Meteor.isServer)

	db.space_users.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();
		doc.modified_by = userId;
		doc.modified = new Date();

		if !doc.space
			throw new Meteor.Error(400, "space_users_error_space_required");

		if !doc.email
			throw new Meteor.Error(400, "email_required");

		if not /^([A-Z0-9\.\-\_\+])*([A-Z0-9\+\-\_])+\@[A-Z0-9]+([\-][A-Z0-9]+)*([\.][A-Z0-9\-]+){1,8}$/i.test(doc.email)
			throw new Meteor.Error(400, "email_format_error");

		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "space_users_error_space_not_found");

		# only space admin or org admin can insert space_users
		if space.admins.indexOf(userId) < 0
			console.log "db.space_users.before.insert,check all doc.organizations's power,doc.organizations:#{doc.organizations}"
			# 要添加用户，需要所有组织都有权限，所以这里必须是判断所有组织都有权限而不是只要一个组织有权限
			isOrgAdmin = Steedos.isOrgAdminByAllOrgIds doc.organizations,userId
			unless isOrgAdmin
				throw new Meteor.Error(400, "organizations_error_org_admins_only")

		creator = db.users.findOne(userId)

		if (!doc.user) && (doc.email)
			userObj = db.users.findOne({"emails.address": doc.email});
			if (userObj)
				doc.user = userObj._id
				doc.name = userObj.name
			else
				user = {}
				if !doc.name
					doc.name = doc.email.split('@')[0]
				doc.user = db.users.insert
					emails: [{address: doc.email, verified: false}]
					name: doc.name
					locale: creator.locale
					spaces_invited: [space._id]

		if !doc.user
			throw new Meteor.Error(400, "space_users_error_user_required");

		if !doc.name
			throw new Meteor.Error(400, "space_users_error_name_required");

		# check space_users exists
		oldUser=db.users.findOne
			"emails.address":doc.email
		existed=db.space_users.find
			"user":oldUser._id,"space":doc.space
		if existed.count()>0
			throw new Meteor.Error(400, "space_users_error_space_users_exists");

		if doc.organizations && doc.organizations.length > 0
			doc.organization = doc.organizations[0]

	db.space_users.after.insert (userId, doc) ->
		console.log("db.space_users_after.insert");
		if doc.organizations
			doc.organizations.forEach (org)->
				organizationObj = db.organizations.findOne(org)
				organizationObj.updateUsers();

		db.users_changelogs.direct.insert
			operator: userId
			space: doc.space
			operation: "add"
			user: doc.user
			user_count: db.space_users.find({space: doc.space, user_accepted: true}).count()

	db.space_users.before.update (userId, doc, fieldNames, modifier, options) ->
		modifier.$set = modifier.$set || {};

		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "space_users_error_space_not_found");

		# only space admin or org admin can update space_users
		if space.admins.indexOf(userId) < 0
			console.log "db.space_users.before.update,check all doc.organizations's power,doc.organizations:#{doc.organizations}"
			# 要修改用户，需要所有组织都有权限，所以这里必须是判断所有组织都有权限而不是只要一个组织有权限
			isOrgAdmin = Steedos.isOrgAdminByAllOrgIds doc.organizations,userId
			unless isOrgAdmin
				throw new Meteor.Error(400, "organizations_error_org_admins_only")

			console.log "db.space_users.before.update,check all modifier.$set.organizations's power,modifier.$set.organizations:#{modifier.$set.organizations}"
			# 变更组织时，需要变更后所有组织都有权限，所以这里必须是判断所有组织都有权限而不是只要一个组织有权限
			isOrgAdmin = Steedos.isOrgAdminByAllOrgIds modifier.$set.organizations,userId
			unless isOrgAdmin
				throw new Meteor.Error(400, "organizations_error_org_admins_only")

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

		if modifier.$set.email
			if modifier.$set.email != doc.email
				throw new Meteor.Error(400, "space_users_error_email_readonly");
		if modifier.$set.space
			if modifier.$set.space != doc.space
				throw new Meteor.Error(400, "space_users_error_space_readonly");
		if modifier.$set.user
			if modifier.$set.user != doc.user
				throw new Meteor.Error(400, "space_users_error_user_readonly");

		if modifier.$set.organizations && modifier.$set.organizations.length > 0
			modifier.$set.organization = modifier.$set.organizations[0]

	db.space_users.after.update (userId, doc, fieldNames, modifier, options) ->
		self = this
		modifier.$set = modifier.$set || {};

		if modifier.$set.name
			db.users.direct.update {_id: doc.user},
				$set:
					name: doc.name

			db.space_users.direct.update {
				user: doc.user
				space: $ne: doc.space
			}, { $set: name: doc.name }, multi: true

		if modifier.$set.organizations
			modifier.$set.organizations.forEach (org)->
				organizationObj = db.organizations.findOne(org)
				organizationObj.updateUsers();
		if this.previous.organizations
			this.previous.organizations.forEach (org)->
				organizationObj = db.organizations.findOne(org)
				organizationObj.updateUsers();

		if modifier.$set.hasOwnProperty("user_accepted")
			if this.previous.user_accepted != modifier.$set.user_accepted
				db.users_changelogs.direct.insert
					operator: userId
					space: doc.space
					operation: modifier.$set.user_accepted ? "enable" : "disable"
					user: doc.user
					user_count: db.space_users.find({space: doc.space, user_accepted: true}).count()


	db.space_users.before.remove (userId, doc) ->
		# check space exists
		space = db.spaces.findOne(doc.space)
		if !space
			throw new Meteor.Error(400, "space_users_error_space_not_found");

		# only space admin or org admin can remove space_users
		if space.admins.indexOf(userId) < 0
			console.log "db.space_users.before.remove,check all doc.organizations's power,doc.organizations:#{doc.organizations}"
			# 要删除用户，需要所有组织都有权限，所以这里必须是判断所有组织都有权限而不是只要一个组织有权限
			isOrgAdmin = Steedos.isOrgAdminByAllOrgIds doc.organizations,userId
			unless isOrgAdmin
				throw new Meteor.Error(400, "organizations_error_org_admins_only")

		# 不能删除当前工作区的拥有者
		if space.owner == doc.user
			throw new Meteor.Error(400, "space_users_error_remove_space_owner");


	db.space_users.after.remove (userId, doc) ->
		console.log("db.space_users.after.remove");
		if doc.organizations
			doc.organizations.forEach (org)->
				organizationObj = db.organizations.findOne(org)
				organizationObj.updateUsers();

		db.users_changelogs.direct.insert
			operator: userId
			space: doc.space
			operation: "delete"
			user: doc.user
			user_count: db.space_users.find({space: doc.space, user_accepted: true}).count()


	Meteor.publish 'space_users', (spaceId)->
		unless this.userId
			return this.ready()

		user = db.users.findOne(this.userId);

		selector = {}
		if spaceId
			selector.space = spaceId
		else
			selector.space = {$in: user.spaces()}

		console.log '[publish] space_users ' + spaceId

		return db.space_users.find(selector)



	Meteor.publish 'my_space_users', ()->
		unless this.userId
			return this.ready()

		console.log '[publish] my_space_users '

		return db.space_users.find({user: this.userId})

	Meteor.publish 'my_space_user', (spaceId)->
		unless this.userId
			return this.ready()

		console.log '[publish] my_space_user '

		return db.space_users.find({space: spaceId, user: this.userId})
