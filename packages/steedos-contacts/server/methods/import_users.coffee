Meteor.methods
	###
		1、校验用户是否存在
		2、校验工作区用户是否存在
		3、校验部门是否存在
		4、校验部门用户是否存在
		TODO: 国际化
	###
	import_users: (space_id, user_pk, data, onlyCheck)->

		_self = this

		if !this.userId
			throw new Meteor.Error(401, "请先登录")

		root_org = db.organizations.findOne({space: space_id, is_company: true})

		space = db.spaces.findOne(space_id)
		if !space || !space?.admins.includes(this.userId)
			throw new Meteor.Error(401, "只有工作区管理员可以导入用户");

		if !space.is_paid
			throw new Meteor.Error(401, "标准版不支持此功能");

		accepted_user_count = db.space_users.find({space: space._id, user_accepted: true}).count()
		if (accepted_user_count + data.length) > space.user_limit 
			c = (accepted_user_count + data.length) - space.user_limit 
			throw new Meteor.Error(400, "需要额外购买" + c + "个用户名额")

		owner_id = space.owner

		testData = []

		errorList = []

		# 数据统一校验

		data.forEach (item, i)->
			# console.log item
			# 用户名，手机号，邮箱不能都为空
			if !item.phone and !item.email
				throw new Meteor.Error(500, "第#{i + 1}行: 手机号，邮箱不能都为空")

			# 判断excel中的数据，用户名、手机号等信息是否有误
			testObj = {}
			if item.username
				testObj.username = item.username
				if testData.filterProperty("username", item.username).length > 0
					throw new Meteor.Error(500, "第#{i + 1}行：用户名重复");

			if item.phone
				testObj.phone = item.phone
				if testData.filterProperty("phone", item.phone).length > 0
					throw new Meteor.Error(500, "第#{i + 1}行：手机号重复");

			if item.email
				if not /^([A-Z0-9\.\-\_\+])*([A-Z0-9\+\-\_])+\@[A-Z0-9]+([\-][A-Z0-9]+)*([\.][A-Z0-9\-]+){1,8}$/i.test(item.email)
					throw new Meteor.Error(500, "第#{i + 1}行：邮件格式错误#{item.email}");
				
				testObj.email = item.email
				if testData.filterProperty("email", item.email).length > 0
					throw new Meteor.Error(500, "第#{i + 1}行：邮件重复");

			item.space = space_id

			testData.push(testObj)

			# 获取查找user的条件
			selector = []
			operating = ""
			if item.username
				selector.push {username: item.username}
			if item.email
				selector.push {"emails.address": item.email}
			if item.phone
				phoneNumber = "+86" + item.phone
				selector.push {"phone.number": phoneNumber}

			userExist = db.users.find({$or: selector})


			# 先判断是否能匹配到唯一的user，然后判断该用户是insert到space_users还是update
			if userExist.count() > 1
				throw new Meteor.Error(500, "第#{i + 1}行：用户名、手机号、邮箱信息有误，无法匹配到同一账号")
			else if userExist.count() == 1
				user = userExist.fetch()[0]._id
				spaceUserExist = db.space_users.find({space: space_id, user: user})
				if spaceUserExist.count() == 1
					operating = "update"
				else if spaceUserExist.count() == 0
					operating = "insert"
			else if userExist.count() == 0
				# 新增space_users的数据校验
				operating = "insert"

			# 判断是否能修改用户的密码
			if item.password and userExist.count() == 1
				if userExist.fetch()[0].services?.password?.bcrypt
					throw new Meteor.Error(500, "第#{i + 1}行：用户已设置密码，不允许修改");

			# 判断部门是否合理
			organization = item.organization

			if !organization
				throw new Meteor.Error(500, "第#{i + 1}行：部门不能为空");

			organization_depts = []

			organizationArrays = organization.split(",")
			organizationArrays.forEach (org, index) ->
				org_depts = org.split("/")
				organization_depts.push(org_depts)

			# console.log organization_depts


			organization_depts.forEach (depts, index) ->
				if depts.length < 1 || depts[0] != root_org.name
					throw new Meteor.Error(500, "第#{i + 1}行：无效的根部门");

			if item.password && user?.services?.password?.bcrypt
				throw new Meteor.Error(500, "第#{i + 1}行：用户已设置密码，不允许修改");

			organization_depts.forEach (depts, index) ->
				depts.forEach (dept_name, index) ->
					if !dept_name
						throw new Meteor.Error(500, "第#{i + 1}行：无效的部门");

<<<<<<< HEAD

		if onlyCheck
			return ;
=======
			if onlyCheck
				return ;

			fullname = root_org.name

			parent_org_id = root_org._id

			organization_depts.forEach (depts, index) ->
				depts.forEach (dept_name, j) ->
					if j > 0
						fullname = fullname + "/" + dept_name

						org = db.organizations.findOne({space: space_id, fullname: fullname})

						if org
							parent_org_id = org._id
						else
							org_doc = {}
							org_doc._id = db.organizations._makeNewID()
							org_doc.space = space_id
							org_doc.name = dept_name
							org_doc.parent = parent_org_id
							org_doc.created = now
							org_doc.created_by = owner_id
							org_doc.modified = now
							org_doc.modified_by = owner_id
							org_id = db.organizations.direct.insert(org_doc)

							if org_id
								org = db.organizations.findOne(org_id)
								updateFields = {}
								updateFields.parents = org.calculateParents()
								updateFields.fullname = org.calculateFullname()

								if !_.isEmpty(updateFields)
									db.organizations.direct.update(org._id, {$set: updateFields})

								if org.parent
									parent = db.organizations.findOne(org.parent)
									db.organizations.direct.update(parent._id, {$set: {children: parent.calculateChildren()}})

								parent_org_id = org_id

			user_id = null
			if user
				user_id = user._id

				#修改space_user 中的position\work_phone\username

				u_update_doc = {}

				su_update_doc = {}

				if item.position
					u_update_doc.position = item.position
					su_update_doc.position = item.position

				if item.work_phone
					u_update_doc.work_phone = item.work_phone
					su_update_doc.work_phone = item.work_phone
>>>>>>> refs/remotes/origin/user_registration_opt

		# 数据导入
		data.forEach (item, i)->
			error = {}
			try 
				selector = []
				operating = ""
				if item.username
					selector.push {username: item.username}
				if item.email
					selector.push {"emails.address": item.email}
				if item.phone
					phoneNumber = "+86" + item.phone
					selector.push {"phone.number": phoneNumber}
				userExist = db.users.find({$or: selector})
				if userExist.count() > 1
					throw new Meteor.Error(400, "用户名、手机号、邮箱信息有误，无法匹配到同一账号")
				else if userExist.count() == 1
					user = userExist.fetch()[0]

				now = new Date()

				organization = item.organization
				organization_depts = organization.split("/");
				fullname = root_org.name
				parent_org_id = root_org._id
				organization_depts.forEach (dept_name, j) ->
					if j > 0
						fullname = fullname + "/" + dept_name

						org = db.organizations.findOne({space: space_id, fullname: fullname})

						if org
							parent_org_id = org._id
						else
							org_doc = {}
							org_doc._id = db.organizations._makeNewID()
							org_doc.space = space_id
							org_doc.name = dept_name
							org_doc.parent = parent_org_id
							org_doc.created = now
							org_doc.created_by = owner_id
							org_doc.modified = now
							org_doc.modified_by = owner_id
							org_id = db.organizations.direct.insert(org_doc)

							if org_id
								org = db.organizations.findOne(org_id)
								updateFields = {}
								updateFields.parents = org.calculateParents()
								updateFields.fullname = org.calculateFullname()

								if !_.isEmpty(updateFields)
									db.organizations.direct.update(org._id, {$set: updateFields})

								if org.parent
									parent = db.organizations.findOne(org.parent)
									db.organizations.direct.update(parent._id, {$set: {children: parent.calculateChildren()}})

								parent_org_id = org_id
				user_id = null
				if user
					user_id = user._id
				else
					udoc = {}
					udoc._id = db.users._makeNewID()
					udoc.steedos_id = item.email || udoc._id
					udoc.locale = db.users.findOne({_id: _self.userId}).locale
					if item.name
						udoc.name = item.name

					if item.email
						udoc.emails = [{address: item.email, verified: false}]

					if item.username
						udoc.username = item.username

					if item.phone
						udoc.phone = {
							number: "+86" + item.phone
							verified: false
							modified: now
						}
					user_id = db.users.insert(udoc)

					if item.password
						Accounts.setPassword(user_id, item.password, {logout: false})

				space_user = db.space_users.findOne({space: space_id, user: user_id})

				space_user_org = db.organizations.findOne({space: space_id, fullname: item.organization})

				if space_user
					if space_user_org
						if !space_user.organizations
							space_user.organizations = []
						space_user.organizations.push(space_user_org._id)

						space_user_update_doc = {}

						space_user_update_doc.organizations = _.uniq(space_user.organizations)

						if item.email
							space_user_update_doc.email = item.email

<<<<<<< HEAD
						if item.name
							space_user_update_doc.name = item.name

						if item.company
							space_user_update_doc.company = item.company
=======
			organizationFullNames = item.organization.split(",")

			# console.log "organizationFullNames is #{organizationFullNames}"

			space_user_orgs = db.organizations.find({space: space_id, fullname: $in:organizationFullNames}).fetch()

			# console.log space_user_orgs.getProperty("_id")

			if space_user
				if space_user_orgs
					if !space_user.organizations
						space_user.organizations = []
					space_user.organizations = space_user.organizations.concat(space_user_orgs.getProperty("_id"))
>>>>>>> refs/remotes/origin/user_registration_opt

						if item.position
							space_user_update_doc.position = item.position

						if item.work_phone
							space_user_update_doc.work_phone = item.work_phone

						if item.phone
							space_user_update_doc.mobile = item.phone

						if item.sort_no
							space_user_update_doc.sort_no = item.sort_no

						if _.keys(space_user_update_doc).length > 0
							db.space_users.update({space: space_id, user: user_id}, {$set: space_user_update_doc})

						if space_user.invite_state == "refused" or space_user.invite_state == "pending"
							throw new Meteor.Error(400, "该用户还未接受加入工作区，不能修改他的个人信息")
						else
							if item.username
								db.users.update({_id: user_id},{$set:{username: item.username}})
							if item.password
								Accounts.setPassword(user_id, item.password, {logout: false})

				else
					if space_user_org
						space_user_org_id = space_user_org._id
						su_doc = {}
						su_doc._id = db.space_users._makeNewID()
						su_doc.space = space_id

						su_doc.user_accepted =  true
						su_doc.invite_state = "accepted"

						if user
							su_doc.user_accepted = false
							su_doc.invite_state = "pending"

<<<<<<< HEAD
						su_doc.name = item.name
						if item.email
							su_doc.email = item.email
						su_doc.organization = space_user_org_id
						su_doc.organizations = [su_doc.organization]
=======
					space_user_orgs.forEach (space_user_org) ->
						space_user_org.updateUsers()
			else
				if space_user_orgs
					space_user_org_ids = space_user_orgs.getProperty("_id")
					su_doc = {}
					su_doc._id = db.space_users._makeNewID()
					su_doc.user = user_id
					su_doc.space = space_id
>>>>>>> refs/remotes/origin/user_registration_opt

						if item.position
							su_doc.position = item.position

						if item.work_phone
							su_doc.work_phone = item.work_phone

						if item.phone
							su_doc.mobile = item.phone

<<<<<<< HEAD
						if item.sort_no
							su_doc.sort_no = item.sort_no
=======
					su_doc.name = item.name
					if item.email
						su_doc.email = item.email
					su_doc.created = now
					su_doc.created_by = owner_id
					su_doc.organization = space_user_org_ids[0]
					su_doc.organizations = space_user_org_ids
>>>>>>> refs/remotes/origin/user_registration_opt

						if item.company
							su_doc.company = item.company

						db.space_users.insert(su_doc)
			catch e
				error.line = i+1
				error.message = e.reason
				errorList.push(error)

<<<<<<< HEAD
		return errorList
=======
					if item.phone
						su_doc.mobile = item.phone

					if item.sort_no
						su_doc.sort_no = item.sort_no

					if item.company
						su_doc.company = item.company

					space_user_id = db.space_users.direct.insert(su_doc)
					if space_user_id
						space_user_orgs.forEach (space_user_org) ->
							space_user_org.updateUsers()

						# users_changelogs
						ucl_doc = {}
						ucl_doc.change_date = moment().format('YYYYMMDD')
						ucl_doc.operator = owner_id
						ucl_doc.space = space_id
						ucl_doc.operation = "add"
						ucl_doc.user = user_id
						ucl_doc.created = now
						ucl_doc.created_by = owner_id

						count = db.space_users.direct.find({space: space_id}).count()
						ucl_doc.user_count = count
						db.users_changelogs.direct.insert(ucl_doc)
>>>>>>> refs/remotes/origin/user_registration_opt
