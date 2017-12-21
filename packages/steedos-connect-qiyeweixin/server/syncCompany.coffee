# 定时器
Meteor.startup ()->
	Meteor.setInterval(Qiyeweixin.startSyncCompany,600000)

# Qiyeweixin.startSyncCompany()
Qiyeweixin.startSyncCompany = ()->
	total = db.spaces.find({'services.qiyeweixin.need_sync':true}).count()
	i = 0
	while(i < total)
		i++
		space = db.spaces.findOne({'services.qiyeweixin.need_sync':true})
		Qiyeweixin.syncCompany space

Qiyeweixin.syncCompany = (space)->
	service = space.services.qiyeweixin
	space_id = space._id
	# 根据永久授权码获取access_token
	o = ServiceConfiguration.configurations.findOne({service: "qiyeweixin"})
	at = Qiyeweixin.getCorpToken o.suite_id,o.corpid,service.permanent_code,o.suite_access_token
	# 当下授权的access_token
	if at&&at.access_token
		service.access_token = at.access_token
	# 当前公司下的全部部门，用于删除多余的
	allOrganizations = []
	# 当前公司下的全部已经添加的用户
	allUsers = []
	# 获取部门列表:ok
	orgList = Qiyeweixin.getDepartmentList service.access_token
	orgIds = orgList.map((m)->return m.id)
	# 如果没有根部门，则初始化根部门
	if orgIds.indexOf(1)==-1
		initRootOrganization space,orgIds
		allOrganizations.push space._id + '-1'
	# 根据部门列表获取当前部门下的成员信息:ok
	orgList.forEach (org)->
		userList = Qiyeweixin.getUserList service.access_token,org.id
		orgUsers = []
		userList.forEach (user)->
			# 管理user表，存在则修改，不存在则新增,并返回user_id
			_id = manageUser user
			# 管理space_user表，，存在则修改，不存在则新增
			user._id = _id
			user.space = space_id
			manageSpaceUser user,orgIds
			orgUsers.push _id
			allUsers.push _id
		org.users = orgUsers
		org._id = space_id + '-' + org.id
		org.fullname = org.name
		org.space = space_id
		org.parent = space_id + '-' + org.parentid
		# 获取当前部门的子部门
		children = orgList.filter((m)->return m.parentid==org.id).map((m)-> return space_id+'-'+m.id)
		org.children = children
		# 根部门-公司
		if org.id == 1
			org.is_company = true
		else
			orgParent = db.organizations.findOne({_id:org.parent},{fullname:1})
			if orgParent && orgParent.fullname
				org.fullname = orgParent.fullname + "/" + org.name
		# 管理organizations表，存在则修改，不存在则新增
		manageOrganizations org
		allOrganizations.push org._id
	# 管理spaces表，增加管理员、拥有者和当前的同步时间
	manageSpaces space
	# 当前公司所有的用户和部门，查找如果当前工作区下有多余的space_user和部门，则删除
	db.space_users.direct.remove({$and:[{space:space_id},{user:$nin:allUsers}]})
	db.organizations.direct.remove({$and:[{space:space_id},{_id:$nin:allOrganizations}]})

initRootOrganization = (space,orgIds)->
	rootOrg = {}
	rootOrg.id = 1
	rootOrg._id = space._id + '-1'
	rootOrg.space = space._id
	rootOrg.name = space.name
	rootOrg.fullname = space.name
	rootOrg.parent = ''
	rootOrg.children = orgIds.map((m)-> return space._id+'-'+m)
	rootOrg.users = []
	rootOrg.is_company = true
	rootOrg.order = 100000000
	manageOrganizations rootOrg

manageSpaces = (space)->
	service = space.services.qiyeweixin
	space_admin_data = Qiyeweixin.getAdminList service.corp_id,service.agentid
	admins = []
	space_admin_data.forEach (admin)->
		if admin.auth_type
			admin_user = db.users.findOne({"services.qiyeweixin.id": admin.userid},{_id:1})
			if admin_user
				admins.push admin_user._id
	doc = {}
	doc.admins = admins
	doc.owner = admins[0]
	doc.modified = new Date
	service.sync_modified = new Date
	service.need_sync = false
	delete service.access_token
	doc.services = {qiyeweixin:service}
	db.spaces.direct.update(space._id, {$set: doc})

manageOrganizations = (organization)->
	org = db.organizations.findOne({_id: organization._id})
	if org
		updateOrganization org,organization
	else
		addOrganization organization

manageSpaceUser = (user,orgIds)->
	su = db.space_users.findOne({user: user._id})
	if su
		updateSpaceUser su,user,orgIds
	else
		addSpaceUser user,orgIds

manageUser = (user)->
	u = db.users.findOne({"services.qiyeweixin.id": user.userid})
	userid = ''
	if u
		userid = u._id
		updateUser u,user
	else
		userid = addUser user
	return userid

addOrganization = (organization)->
	doc = {}
	doc._id = organization._id
	doc.space = organization.space
	doc.name = organization.name
	doc.fullname = organization.fullname
	if organization.is_company
		doc.is_company = true
	doc.parent = organization.parent
	parents = []
	parents.push organization.parent
	doc.parents = parents
	doc.children = organization.children
	doc.users = organization.users
	doc.sort_no = organization.order
	doc.created = new Date
	doc.modified = new Date 
	db.organizations.direct.insert doc
addSpaceUser = (user,orgIds)->
	doc = {}
	doc._id = user.space + '-' +user.userid #_id = 工作区id-用户id
	doc.user = user._id
	doc.name = user.name
	doc.space = user.space
	#部门id = 工作区id-部门号
	organizations = user.department.filter((m)-> return m==1||orgIds.indexOf(m)>-1).map((m)-> return user.space+"-"+m)
	if organizations==null||organizations.length==0
		organizations.push user.space+"-1"
	doc.organizations = organizations
	doc.organization = doc.organizations[0]
	doc.user_accepted = true
	doc.created = new Date
	doc.modified = new Date
	doc.position = user.position
	doc.sort_no = user.order[0]
	db.space_users.direct.insert doc
addUser = (user)->
	doc = {}
	doc._id = db.users._makeNewID()
	doc.steedos_id = doc._id
	doc.name = user.name
	doc.avatarURL = user.avatar
	doc.locale = "zh-cn"
	doc.is_deleted = false
	doc.created = new Date
	doc.modified = new Date
	doc.services = {qiyeweixin:{id: user.userid}}
	userid = db.users.insert(doc)
	return userid
updateOrganization = (old_org,new_org)->
	doc = {}
	if old_org.name != new_org.name
		doc.name = new_org.name
	if old_org.fullname != new_org.fullname
		doc.fullname = new_org.fullname
	if old_org.sort_no != new_org.order
		doc.sort_no = new_org.order
	if old_org.parent != new_org.parent
		doc.parent = new_org.parent
	parents = []
	parents.push new_org.parent
	doc.parents = parents
	if old_org.users.sort().toString() != new_org.users.sort().toString()
		doc.users = new_org.users
	if old_org.children.sort().toString() != new_org.children.sort().toString()
		doc.children = new_org.children
	if doc.hasOwnProperty('name') || doc.hasOwnProperty('fullname') || doc.hasOwnProperty('sort_no') || doc.hasOwnProperty('parent') || doc.hasOwnProperty('users') || doc.hasOwnProperty('children')
		doc.modified = new Date
		db.organizations.direct.update(old_org._id, {$set: doc})
updateSpaceUser = (old_su,new_su,orgIds)->
	doc = {}
	if old_su.name != new_su.name
		doc.name = new_su.name
	if old_su.position != new_su.position || !old_su.position
		doc.position = new_su.position
	if old_su.sort_no != new_su.order[0]
		doc.sort_no = new_su.order[0]
	organizations = new_su.department.filter((m)-> return m==1||orgIds.indexOf(m)>-1).map((m)-> return new_su.space+"-"+m)
	if old_su.organizations.sort().toString() != organizations.sort().toString()
		doc.organizations = organizations
		doc.organization = organizations[0]
	if doc.hasOwnProperty('name') || doc.hasOwnProperty('sort_no') || doc.hasOwnProperty('organization')
		doc.modified = new Date
		db.space_users.direct.update(old_su._id, {$set: doc})
updateUser = (old_user,new_user)->
	doc = {}
	if old_user.name != new_user.name
		doc.name = new_user.name
	if old_user.avatarURL != new_user.avatar
		doc.avatarURL = new_user.avatar
	if doc.hasOwnProperty('name') || doc.hasOwnProperty('avatarURL')
		doc.modified = new Date
		db.users.update(old_user._id, {$set: doc})

	

