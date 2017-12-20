# ServiceConfiguration.configurations.upsert(
#   { service: 'qiyeweixin' },
#   {
#     $set: {
# 	    token: "steedos",
# 		encodingAESKey: "vr8r85bhgaruo482zilcyf6uezqwpxpf88w77t70dow",
# 		corpid: "wweee647a39f9efa30",
# 		provider_secret:"TV7SN_yriFNdL5Fc3V_DXncINv36EhlvJBGPD01D-Cw",
# 		suite_id: "tje46bd4191785f45a",
#     	suite_secret: "dVh0AjRVLDvqwaSUDBQlc39Moeo2HQ0go_UVkLYzqps",
#     	suite_ticket:"",
#     	suite_access_token:""
#     }
#   }
# );
@Init = {}
# Init.testCreateOrganization()
Init.testCreateOrganization = ()->
	org = { id: 1, name: '上海华炎软件科技有限公司', parentid: 0, order: 100000000 }
	user_data = [
		{
			userid: 'ZhuangJianGuo',
			name: '庄建国',
			department: [ 1,2 ],
			position: '',
			gender: '1',
			avatar: 'http://p.qlogo.cn/bizmail/Ige40uvGu3aTucNNPATanYiaDDp8ZpvSK6RHD8gksjjTibB5KkXiaH9Bw/0',
			status: 1,   
			isleader: 1,
			english_name: '',
			order: [ 12288 ]
		},
		{
			userid: 'LiZheng',
			name: '李征',
			department: [ 1,3 ],
			position: '',
			gender: '1',
			avatar: 'http://p.qlogo.cn/bizmail/PmWNCxGwjF1ib6Ubl8pOjRojBMHRxLHEhjX10XSUaMq2cF0FAQWVNJg/0',
			status: 1,
			isleader: 0,
			english_name: '',
			order: [ 0 ]
		}
	]
	space_id = 'qywx-123456879'
	createOrganization org,user_data,space_id

createOrganization = (org,user_data,space_id)->

	
createSpaceUser = (user,org,space_id)->



















# Init.test()
Init.test = ()->
	delete_users = []
	delete_users = db.space_users.find({space:'MxrepyTjjXuZ7jg3B'},fields: {_id:1})
	delete_users.forEach (delete_user)->
		db.users.direct.remove({_id: delete_user._id})


# Init.testCreateOrganization()
Init.testCreateOrganization = ()->
	space_id = "qywx-MxrepyTjjXuZ7jg3B"
	org_data = [
		{ id: 1, name: '上海华炎软件科技有限公司', parentid: 0, order: 100000000 },
		{ id: 2, name: '研发1部', parentid: 1, order: 99997500 },
		{ id: 3, name: '研发2 部', parentid: 1, order: 99998250 },
		{ id: 4, name: '行政部', parentid: 1, order: 99998000 },
		{ id: 5, name: '华炎信息', parentid: 1, order: 99997000 },
		{ id: 6, name: '行政部', parentid: 5, order: 100000000 },
		{ id: 7, name: '行政1部', parentid: 6, order: 100000000 },
		{ id: 8, name: '行政2部', parentid: 6, order: 99999000 }
	]
	user_data = [
		{
			userid: 'ZhuangJianGuo',
			name: '庄建国',
			department: [ 1 ],
			position: '',
			gender: '1',
			avatar: 'http://p.qlogo.cn/bizmail/Ige40uvGu3aTucNNPATanYiaDDp8ZpvSK6RHD8gksjjTibB5KkXiaH9Bw/0',
			status: 1,   
			isleader: 1,
			english_name: '',
			order: [ 12288 ]
		}
	]
	createOrganization org_data,user_data,space_id

createOrganization = (org_data,user_data,space_id)->
	org_data.forEach (org) ->
		org_doc = {}
		org_doc._id = "qywx-" + corpid + "-" + org.id
		org_doc.space = space_id
		org_doc.name = org.name
		if org.parentid >= 1
			org_doc.parent = space_id + "-" + org.parentid
		if org.id == 1
			org_doc.is_company = true
		
		org_doc.sort_no = org.order
		org_doc.created = new Date

		db.organizations.direct.insert(org_doc)








# Init.testManageUser()
Init.testManageUser = ()->
	user = {
		userid: 'ZongLu111',
		name: '宗路',
		department: [ 2 ],
		position: '',
		gender: '1',
		avatar: 'http://p.qlogo.cn/bizmail/w6Vq2Y7aTehrOdWIr1IicHagZwgWPmIPwfXIqIabcmh1ZjaTxHMrtGw/0',
		status: 1,
		isleader: 0,
		english_name: '',
		order: [ 0 ]
	}
	manageUser user
manageUser = (u)->
	uq = db.users.find {"services.qiyeweixin.id": u.userid}
	# 如果审批王中存在该用户，则修改用户信息
	if uq.count()>0
		user = uq.fetch()[0]
		modifyUser user,u
	else
		# 创建新用户
		createUser u
# 修改用户方法(授权企业初始化时候使用的更新用户方法)
modifyUser = (old_user,new_user)->
	doc = {}
	if old_user.name != new_user.name
		doc.name = new_user.name
	if old_user.avatarURL != new_user.avatar
		doc.avatarURL = new_user.avatar
	if old_user.is_deleted
		doc.is_deleted = false
	if doc.hasOwnProperty('name') || doc.hasOwnProperty('avatar') || doc.hasOwnProperty('is_deleted')
		doc.modified = new Date()
		db.users.direct.update old_user._id, {$set: doc}
createUser = (user)->
	doc = {}
	doc._id = db.users._makeNewID()
	doc.steedos_id = doc._id
	doc.email = user.userid
	doc.name = user.name
	doc.locale = "zh-cn"
	doc.is_deleted = false
	doc.created = new Date
	doc.modified = new Date
	doc.services = {qiyeweixin:{id: user.userid}}
	doc.avatarURL = user.avatar
	db.users.direct.insert(doc)


# Init.testManageSpace()
Init.testManageSpace = ()->
	auth_corp_info = {
		corpid: 'wweee647a39f9efa30',
		corp_name: '华炎软件',
		corp_type: 'unverified',
		corp_round_logo_url: '',
		corp_square_logo_url: 'http://p.qlogo.cn/bizmail/w4XRTc1WPc5wo61Vv2QjQ8vLASZgBIiahqTiaTYoQnU3F1IB44Ca426g/0',
		corp_user_max: 200,
		corp_agent_max: 0,
		corp_wxqrcode: 'http://p.qpic.cn/pic_wework/3070367403/9c9a1f94d3109c48c92ac5626dfedaa4dbff38cef1c5bc0a/0',
		corp_full_name: '',
		subject_type: 1,
		verified_end_time: 0
	}
	auth_info = {
		agent:[{ 
			agentid: 1000050,
			name: '审批王Test',
			square_logo_url: 'https://p.qlogo.cn/bizmail/A34K8Pxz8h0ibfHqj9YicClj68mRmJVSVG89OVbSptpqvTguQUeKCJwA/0',
			appid: 1,
			api_group: [],
			privilege: [Object]
		}],
		department: [] 
	}
	access_token = "S1oo3G7W"
	permanent_code = "fFds6gS"
	manageSpace auth_corp_info,auth_info,access_token,permanent_code

manageSpace = (auth_corp_info,auth_info)->
	space_admin_data = Qiyeweixin.getAdminList auth_corp_info.corpid,auth_info.agent[0].agentid
	admins = []
	space_admin_data.forEach (admin)->
		if admin.auth_type
			admin_user = db.users.findOne({"services.qiyeweixin.id": admin.userid})
			if admin_user
				admins.push admin_user._id
	space_data = auth_corp_info
	space_data._id = "qywx-" + space_data.corpid
	space_data.owner = admins[0]
	space_data.admins = admins
	space_data.access_token = access_token
	if permanent_code
		space_data.permanent_code = permanent_code
	else
		space_data.permanent_code = ""
	console.log space_data
	# 工作区id：查找当前工作区是否存在，存在则修改工作区信息，否则新增工作区
	sq = db.spaces.find({_id: space_data._id})
	if sq.count() > 0
		old_space = sq.fetch()[0]
		new_space = space_data
		modifySpace old_space,new_space
	else
		# 新建工作区信息
		createSpace space_data

modifySpace = (old_space,new_space)->
	console.log "修改工作区"
	s_doc = {}
	if old_space.name != new_space.corp_name
		s_doc.name = new_space.corp_name
	if old_space.owner != new_space.owner
		s_doc.owner = new_space.owner
	if old_space.admins.sort().toString() != new_space.admins.sort().toString()
		s_doc.admins = new_space.admins
	if s_doc.hasOwnProperty('name') || s_doc.hasOwnProperty('owner') || s_doc.hasOwnProperty('admins')
		s_doc.modified = new Date
		s_doc.modified_by = new_space.owner
		s_qywx = old_space.services.qiyeweixin
		s_qywx.access_token = new_space.access_token
		s_qywx.permanent_code = new_space.permanent_code
		s_doc['services.qiyeweixin'] = s_qywx
		db.spaces.direct.update(old_space._id, {$set: s_doc})

createSpace = (space_data)->
	console.log "新增工作区"
	s_doc = {}
	s_doc._id = space_data._id
	s_doc.name = space_data.corp_name
	s_doc.owner = space_data.owner
	s_doc.admins = space_data.admins
	s_doc.is_deleted = false
	s_doc.created = new Date
	s_doc.created_by = space_data.owner
	s_doc.modified = new Date
	s_doc.modified_by = space_data.owner
	s_doc.services = { qiyeweixin:{ corp_id: space_data.corpid, access_token: space_data.access_token, permanent_code: space_data.permanent_code}}
	space_id = db.spaces.direct.insert(s_doc)


# Init.testManageOrganizations()
Init.testManageOrganizations = ()->
	# 根部门为1
	user_data = [
		{
			userid: 'ZhuangJianGuo',
			name: '庄建国',
			department: [ 1 ],
			position: '',
			gender: '1',
			avatar: 'http://p.qlogo.cn/bizmail/Ige40uvGu3aTucNNPATanYiaDDp8ZpvSK6RHD8gksjjTibB5KkXiaH9Bw/0',
			status: 1,   
			isleader: 1,
			order: [ 12288 ]
		},
		{
			userid: 'LiZheng',
			name: '李征',
			department: [ 1 ],
			position: '',
			gender: '1',
			avatar: 'http://p.qlogo.cn/bizmail/PmWNCxGwjF1ib6Ubl8pOjRojBMHRxLHEhjX10XSUaMq2cF0FAQWVNJg/0',
			status: 1,
			isleader: 0,
			english_name: '',
			order: [ 0 ]
		},
		{
			userid: 'LiMingLang',
			name: '李明朗',
			department: [ 5 ],
			position: '',
			gender: '1',
			avatar: 'http://p.qlogo.cn/bizmail/icq5qCLRPZ8YqvmpyINwvhQFhGqG2ZhzMSSELotyzPxzmGQeHgEzicog/0',
			status: 1,
			isleader: 0,
			english_name: '',
			order: [ 0 ]
		},
		{
			userid: 'ZongLu',
			name: '宗路',
			department: [ 2 ],
			position: '',
			gender: '1',
			avatar: 'http://p.qlogo.cn/bizmail/w6Vq2Y7aTehrOdWIr1IicHagZwgWPmIPwfXIqIabcmh1ZjaTxHMrtGw/0',
			status: 1,
			isleader: 0,
			english_name: '',
			order: [ 0 ]
		}
	]
	org_data = [
			{ id: 1, name: '上海华炎软件科技有限公司', parentid: 0, order: 100000000 },
			{ id: 2, name: '研发1部', parentid: 1, order: 99997500 },
			{ id: 3, name: '研发2 部', parentid: 1, order: 99998250 },
			{ id: 4, name: '行政部', parentid: 1, order: 99998000 },
			{ id: 5, name: '华炎信息', parentid: 1, order: 99997000 },
			{ id: 6, name: '行政部', parentid: 5, order: 100000000 },
			{ id: 7, name: '行政1部', parentid: 6, order: 100000000 },
			{ id: 8, name: '行政2部', parentid: 6, order: 99999000 }
		]
	space = 'qywx-wweee647a39f9efa30'
	manageOrganizations org_data,user_data,space

manageOrganizations = (orgs,users,space)->
	orgs.forEach (o) ->












