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
		optional: true,
		autoform:
			type: ->
				if Steedos.isPhoneEnabled()
					return "text"
				else
					return "hidden"
			readonly: ->
				if Steedos.isPaidSpace()
					return false
				else
					return true
	work_phone:
		type: String,
		optional: true
	position:
		type: String,
		optional: true
	hr:
		type: Object,
		optional: true,
		blackbox: true
		autoform:
			omit: true
	company:
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
			# 要修改用户，需要所有组织都有权限，所以这里必须是判断所有组织都有权限而不是只要一个组织有权限
			isOrgAdmin = Steedos.isOrgAdminByAllOrgIds doc.organizations,userId
			unless isOrgAdmin
				throw new Meteor.Error(400, "organizations_error_org_admins_only")

			# 变更组织时，需要变更后所有组织都有权限，所以这里必须是判断所有组织都有权限而不是只要一个组织有权限
			isOrgAdmin = Steedos.isOrgAdminByAllOrgIds modifier.$set.organizations,userId
			unless isOrgAdmin
				throw new Meteor.Error(400, "organizations_error_org_admins_only")

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

		if modifier.$set.user_accepted != undefined and !modifier.$set.user_accepted
			if space.admins.indexOf(doc.user) > 0 || doc.user == space.owner
				throw new Meteor.Error(400,"organizations_error_can_not_set_checkbox_true")


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

		if modifier.$set.mobile
			if  modifier.$set.mobile != doc.mobile
				number = "+86" + modifier.$set.mobile
				# 修改人
				euser = db.users.findOne({_id: Meteor.userId()},{fields: {name: 1}})
				
				repeatNumberUser = db.users.findOne({'phone.number':number},{fields:{_id:1,phone:1}})
				if repeatNumberUser
					throw new Meteor.Error(400, "space_users_error_phone_already_existed")
				else if Steedos.isPhoneEnabled()
					modifier_mobile_user = db.users.findOne({mobile: modifier.$set.mobile},{fields: {locale: 1}})
					lang_modifier = 'en'
					if modifier_mobile_user?.locale is 'zh-cn'
						lang_modifier = 'zh-CN'
					params = {
						name: euser.name,
						number: modifier.$set.mobile
					}
					paramString = JSON.stringify(params)

					if doc.mobile
						doc_user = db.users.findOne({_id: doc.user},{fields: {locale: 1}})
						lang = 'en'
						if doc_user?.locale is 'zh-cn'
							lang = 'zh-CN'
						# 发送手机短信
						SMSQueue.send({
							Format: 'JSON',
							Action: 'SingleSendSms',
							ParamString: paramString,
							RecNum: doc.mobile,
							SignName: 'OA系统',
							TemplateCode: 'SMS_67660108',
							msg: TAPi18n.__('sms.chnage_mobile.template', params, lang)
						})

					# 发送手机短信
					SMSQueue.send({
						Format: 'JSON',
						Action: 'SingleSendSms',
						ParamString: paramString,
						RecNum: modifier.$set.mobile,
						SignName: 'OA系统',
						TemplateCode: 'SMS_67660108',
						msg: TAPi18n.__('sms.chnage_mobile.template', params, lang)
					})

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

		if modifier.$set.position
			db.users.direct.update {_id: doc.user},
				$set:
					position: doc.position
		
		if modifier.$set.work_phone
			db.users.update {_id: doc.user},
				$set:
					work_phone: doc.work_phone

		if doc.mobile
			user_set = {}
			user_set.phone = {}
			user_set.mobile = doc.mobile
			# 目前只考虑国内手机
			user_set.phone.number = "+86" + doc.mobile
			user_set.phone.verified = true
			user_set.phone.modified = new Date()
			if not _.isEmpty(user_set)
				# 更新users表中的相关字段
				db.users.update({_id: doc.user}, {$set: user_set})
		else
			user_unset = {}
			user_unset.phone = ""
			user_unset.mobile = ""
			# 更新users表中的相关字段
			db.users.update({_id: doc.user}, {$unset: user_unset})


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
			# 要删除用户，需要所有组织都有权限，所以这里必须是判断所有组织都有权限而不是只要一个组织有权限
			isOrgAdmin = Steedos.isOrgAdminByAllOrgIds doc.organizations,userId
			unless isOrgAdmin
				throw new Meteor.Error(400, "organizations_error_org_admins_only")

		# 不能删除当前工作区的拥有者
		if space.owner == doc.user
			throw new Meteor.Error(400, "space_users_error_remove_space_owner");

		if space.admins.indexOf(doc.user) > 0
			throw new Meteor.Error(400,"space_users_error_remove_space_admins");


	db.space_users.after.remove (userId, doc) ->
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


		return db.space_users.find(selector)



	Meteor.publish 'my_space_users', ()->
		unless this.userId
			return this.ready()


		return db.space_users.find({user: this.userId})

	Meteor.publish 'my_space_user', (spaceId)->
		unless this.userId
			return this.ready()


		return db.space_users.find({space: spaceId, user: this.userId})

if Meteor.isServer
	db.space_users._ensureIndex({
		"user": 1
	},{background: true})

	db.space_users._ensureIndex({
		"user_accepted": 1
	},{background: true})

	db.space_users._ensureIndex({
		"space": 1
	},{background: true})

	db.space_users._ensureIndex({
		"is_deleted": 1
	},{background: true})

	db.space_users._ensureIndex({
		"user": 1,
		"user_accepted": 1
	},{background: true})

	db.space_users._ensureIndex({
		"user": 1,
		"space": 1
	},{background: true})

	db.space_users._ensureIndex({
		"space": 1,
		"user_accepted": 1
	},{background: true})

	db.space_users._ensureIndex({
		"space": 1,
		"user": 1,
		"user_accepted": 1
	},{background: true})

	db.space_users._ensureIndex({
		"space": 1,
		"manager": 1
	},{background: true})

	db.space_users._ensureIndex({
		"manager": 1
	},{background: true})

	db.space_users._ensureIndex({
		"space": 1,
		"created": 1
	},{background: true})

	db.space_users._ensureIndex({
		"space": 1,
		"created": 1,
		"modified": 1
	},{background: true})

	db.space_users._ensureIndex({
		"organizations": 1
	},{background: true})