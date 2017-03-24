Admin = {}


# Filter data on server by space field
Admin.selectorCheckSpaceAdmin = (userId) ->
	if Meteor.isClient
		userId = Meteor.userId()
		unless userId
			return {make_a_bad_selector: 1}
		if Steedos.isSpaceAdmin()
			return {space: Session.get("spaceId")}
		else
			return {make_a_bad_selector: 1}

	if Meteor.isServer
		unless userId
			return {make_a_bad_selector: 1}
		user = db.users.findOne(userId, {fields: {is_cloudadmin: 1}})
		if !user
			return {make_a_bad_selector: 1}
		selector = {}
		if !user.is_cloudadmin
			spaces = db.spaces.find({admins:{$in:[userId]}}, {fields: {_id: 1}}).fetch()
			spaces = spaces.map (n) -> return n._id
			selector.space = {$in: spaces}
		return selector


# Filter data on server by space field
Admin.selectorCheckSpace = (userId) ->
	if Meteor.isClient
		userId = Meteor.userId()
		unless userId
			return {make_a_bad_selector: 1}
		spaceId = Session.get("spaceId");
		if spaceId
			if db.space_users.findOne({user: userId,space: spaceId}, {fields: {_id: 1}})
				return {space: spaceId}
			else
				return {make_a_bad_selector: 1}
		else
			return {make_a_bad_selector: 1}

	if Meteor.isServer
		unless userId
			return {make_a_bad_selector: 1}
		user = db.users.findOne(userId, {fields: {_id: 1}})
		if !user
			return {make_a_bad_selector: 1}
		selector = {}
		space_users = db.space_users.find({user: userId}, {fields: {space: 1}}).fetch()
		spaces = []
		_.each space_users, (u)->
			spaces.push(u.space)
		selector.space = {$in: spaces}
		return selector


if Meteor.isClient
	###
	admin_menus：
	{
		_id: xxx
		title: "Steedos Workflow"
		icon:""
		url: ""
		onclick: ->
		app: "workflow"
		roles:["space_admin", "space_owner", "cloud_admin"]
		sort: 30
		parent: parentId
	}
	###
	db.admin_menus = new Meteor.Collection()

	Admin.addMenu = (menu)->
		unless menu
			return false
		unless typeof menu._id == "string"
			return false
		return db.admin_menus.insert menu


	# 账户设置
	Admin.addMenu 
		_id: "account"
		title: "Account Settings"
		icon: "ion ion-android-person"
		sort: 10

	Admin.addMenu 
		_id: "profile"
		title: "Profile"
		icon:"ion ion-android-person"
		url: "/admin/profile/profile"
		sort: 10
		parent: "account"

	Admin.addMenu 
		_id: "avatar"
		title: "Avatar"
		icon:"ion ion-image"
		url: "/admin/profile/avatar"
		sort: 20
		parent: "account"

	Admin.addMenu 
		_id: "account_info"
		title: "Account"
		icon:"ion ion-locked"
		url: "/admin/profile/account"
		sort: 30
		parent: "account"

	Admin.addMenu 
		_id: "email"
		title: "email"
		icon:"ion ion-locked"
		url: "/admin/profile/emails"
		sort: 40
		parent: "account"

	Admin.addMenu 
		_id: "personalization"
		title: "personalization"
		icon:"ion ion-wand"
		url: "/admin/profile/personalization"
		sort: 50
		parent: "account"


	# 工作区设置





	Admin.MENUS = [
		{
			title: "Account Settings"
			icon:"ion ion-android-person"
			sort: 10
			items:  [{
				title: "Profile"
				icon:"ion ion-android-person"
				url: "/admin/profile/profile"
				sort: 1
			},{
				title: "Avatar"
				icon:"ion ion-image"
				url: "/admin/profile/avatar"
				sort: 1
			},{
				title: "Account"
				icon:"ion ion-locked"
				url: "/admin/profile/account"
				sort: 1
			},{
				title: "email"
				icon:"ion ion-locked"
				url: "/admin/profile/emails"
				sort: 1
			},{
				title: "personalization"
				icon:"ion ion-wand"
				url: "/admin/profile/personalization"
				sort: 1
			}]
		},{
			title: "spaces"
			icon:"ion ion-ios-cloud-outline"
			sort: 20
			roles:["space_admin", "space_owner", "cloud_admin"]
			items:  [{
				title: "Admin Profile"
				icon:""
				url: ""
				onclick: ->
				roles:["space_admin", "space_owner", "cloud_admin"]
				sort: 1
			}]
		},{
			title: "Steedos Workflow"
			icon:""
			app: "workflow"
			sort: 30
			roles:["space_admin", "space_owner", "cloud_admin"]
			items:  [{
				title: "Admin Profile"
				icon:""
				url: ""
				onclick: ->
				roles:["space_admin", "space_owner", "cloud_admin"]
				sort: 1
			}]
		}
	]