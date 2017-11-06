Meteor.methods
	###
		1、校验用户是否存在
		2、校验工作区用户是否存在
		3、校验部门是否存在
		4、校验部门用户是否存在
		TODO: 国际化
	###
	import_users: (space_id, user_pk, data, onlyCheck)->

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

		data.forEach (item, i)->
			console.log("item", item)
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

			testData.push(testObj)


			if (_.keys(item).join(",") == 'username,password' || _.keys(item).join(",") == 'password,username')
				if !item.username
					throw new Meteor.Error(500, "第#{i + 1}行：用户名不能为空");
				if !item.password
					throw new Meteor.Error(500, "第#{i + 1}行：密码不能为空");

				user1 = db.users.findOne({username: item.username})

				if !user1
					throw new Meteor.Error(500, "第#{i + 1}行：无效的用户名");

				if user1.services?.password?.bcrypt
					throw new Meteor.Error(500, "第#{i + 1}行：用户已设置密码，不允许修改");

				space_user1 = db.space_users.findOne({user: user1._id, space: space._id})

				if !space_user1
					throw new Meteor.Error(500, "第#{i + 1}行：无效的用户名");

				if onlyCheck
					return

				Accounts.setPassword(user1._id, item.password, {logout: false})

				return;

			now = new Date()

			organization = item.organization

			if !organization
				throw new Meteor.Error(500, "第#{i + 1}行：部门不能为空");

			organization_depts = organization.split("/");

			if organization_depts.length < 1 || organization_depts[0] != root_org.name
				throw new Meteor.Error(500, "第#{i + 1}行：无效的根部门");

			if !item.email && !item.phone && user_pk != 'username'
				throw new Meteor.Error(500, "第#{i + 1}行：邮箱不能为空");


			# 获取用户

			if user_pk == 'username'
				if !item.username
					throw new Meteor.Error(500, "第#{i + 1}行：用户名不能为空");
				user = db.users.findOne({username: item.username})
				if item.phone
					phoneNumber = "+86" + item.phone
					user_phone_check = db.users.find({"phone.number": phoneNumber}).fetch()
					if user_phone_check.length > 1
						throw new Meteor.Error(500, "第#{i + 1}行：手机号已被占用")
					else if user_phone_check.length == 1
						if user_phone_check[0]._id != user?._id
							throw new Meteor.Error(500, "第#{i + 1}行：手机号已被占用")
				if item.email
					user_email_check = db.users.find({"email.address": item.email}).fetch()
					if user_email_check.length > 1
						throw new Meteor.Error(500, "第#{i + 1}行：邮件已被占用")
					if user_email_check.length == 1
						if user_email_check[0]._id != user?._id
							throw new Meteor.Error(500, "第#{i + 1}行：邮件已被占用")
				
			else if user_pk == 'phone'
				if !item.phone
					throw new Meteor.Error(500, "第#{i + 1}行：手机号不能为空");
				phoneNumber = "+86" + item.phone
				user = db.users.findOne({"phone.number": phoneNumber})
				if item.username
					user_username_check = db.users.find({username: item.username}).fetch()
					if user_username_check.length > 1
						throw new Meteor.Error(500, "第#{i + 1}行：用户名已被占用")
					else if user_username_check.length == 1
						if user_username_check[0]._id != user?._id
							throw new Meteor.Error(500, "第#{i + 1}行：用户名已被占用")
				if item.email
					user_email_check = db.users.find({"email.address": item.email}).fetch()
					if user_email_check.length > 1
						throw new Meteor.Error(500, "第#{i + 1}行：邮件已被占用")
					if user_email_check.length == 1
						if user_email_check[0]._id != user?._id
							throw new Meteor.Error(500, "第#{i + 1}行：邮件已被占用")
			else
				user = db.users.findOne({"emails.address": item.email})
				if item.phone
					phoneNumber = "+86" + item.phone
					user_phone_check = db.users.find({"phone.number": phoneNumber}).fetch()
					if user_phone_check.length > 1
						throw new Meteor.Error(500, "第#{i + 1}行：手机号已被占用")
					else if user_phone_check.length == 1
						if user_phone_check[0]._id != user?._id
							throw new Meteor.Error(500, "第#{i + 1}行：手机号已被占用")
				if item.username
					user_username_check = db.users.find({username: item.username}).fetch()
					if user_username_check.length > 1
						throw new Meteor.Error(500, "第#{i + 1}行：用户名已被占用")
					else if user_username_check.length == 1
						if user_username_check[0]._id != user?._id
							throw new Meteor.Error(500, "第#{i + 1}行：用户名已被占用")

			# 校验手机号是否被占用
			# if item.phone

			# 	user_by_phone = db.users.find({"phone.number": item.phone})

			# 	if user_by_phone.count() > 1
			# 		throw new Meteor.Error(500, "第#{i + 1}行：手机号已被占用");

			# 	if user_by_phone.count() == 1
			# 		if user_pk == 'username'
			# 			if user_by_phone.fetch()[0]["username"] != item.username
			# 				throw new Meteor.Error(500, "第#{i + 1}行：手机号已被占用");
			# 		if user_pk == 'email'
			# 			if user_by_phone.fetch()[0]?.emails?[0].address != item.email
			# 				throw new Meteor.Error(500, "第#{i + 1}行：手机号已被占用");

			# if item.email

			# 	user_by_email = db.users.findOne({"emails.address": item.email})

			# 	if user

			# 		if user_pk == 'username'
			# 			if item.email != user.steedos_id
			# 				if user_by_email
			# 					throw new Meteor.Error(500, "第#{i + 1}行：邮件已被占用");

				# ck_space_user = db.space_users.findOne({space: space_id, user: user._id})

				# if !ck_space_user
				# 	throw new Meteor.Error(500, "第#{i + 1}行：用户已属于其他工作区，不能通过导入功能添加此用户；您可以通过邮箱邀请此用户");

			if item.password && user?.services?.password?.bcrypt
				throw new Meteor.Error(500, "第#{i + 1}行：用户已设置密码，不允许修改");

			organization_depts.forEach (dept_name, j) ->
				if !dept_name
					throw new Meteor.Error(500, "第#{i + 1}行：无效的部门");

			if onlyCheck
				return ;

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

				#修改space_user 中的position\work_phone\username

				u_update_doc = {}

				su_update_doc = {}

				if item.position
					u_update_doc.position = item.position
					su_update_doc.position = item.position

				if item.work_phone
					u_update_doc.work_phone = item.work_phone
					su_update_doc.work_phone = item.work_phone

				if item.username
					u_update_doc.username = item.username

				if item.phone
					u_update_doc.phone = {
						number: "+86" + item.phone
						verified: false
						modified: now
					}
					# u_update_doc.mobile = item.phone 未通过验证,不设置mobile
					su_update_doc.mobile = item.phone

				# 更新用户Email字段
				if user_pk == 'username'
					if item.email
						su_update_doc.email = item.email
#						u_update_doc.steedos_id = item.email

						if user.emails
							_address = user.emails.filterProperty("address", item.email)
							if _address.length < 1
								u_update_doc.emails = user.emails.concat([{address: item.email, verified: false}])
						else
							u_update_doc.emails = [{address: item.email, verified: false}]

				if _.keys(u_update_doc).length > 0
					db.users.direct.update({_id: user_id},{$set:u_update_doc})

#				console.log su_update_doc
				if _.keys(su_update_doc).length > 0
					db.space_users.direct.update({user: user_id}, {$set: su_update_doc})

				if item.password
					Accounts.setPassword(user_id, item.password, {logout: false})

			else
				udoc = {}
				udoc._id = db.users._makeNewID()

				if item.email
					udoc.steedos_id = item.email
				else if item.username
					udoc.steedos_id = item.username
				else
					udoc.steedos_id = udoc._id

				udoc.name = item.name
				udoc.locale = "zh-cn"
				udoc.is_deleted = false
				if item.email
					udoc.emails = [{address: item.email, verified: false}]
				udoc.services = {password: {bcrypt: "$2a$10$o2qrOKUtfICH/c3ATkxrwu11h5u5I.Mc4ANU6pMbBjUaNs6C3f2sG"}}
				udoc.created = now
				udoc.modified = now
				udoc.utcOffset = 8

				if item.position
					udoc.position = item.position

				if item.work_phone
					udoc.work_phone = item.work_phone

				if item.username
					udoc.username = item.username

				if item.phone
					udoc.phone = {
						number: "+86" + item.phone
						verified: false
						modified: now
					}

					# udoc.mobile = item.phone 未通过验证,不设置mobile

				user_id = db.users.direct.insert(udoc)

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

					if item.position
						space_user_update_doc.position = item.position

					if item.work_phone
						space_user_update_doc.work_phone = item.work_phone

					if item.phone
						space_user_update_doc.mobile = item.phone

					if item.sort_no
						space_user_update_doc.sort_no = item.sort_no

					if item.company
						space_user_update_doc.company = item.company

					if _.keys(space_user_update_doc).length > 0
						db.space_users.direct.update({space: space_id, user: user_id}, {$set: space_user_update_doc})

					space_user_org.updateUsers()
			else
				if space_user_org
					space_user_org_id = space_user_org._id
					su_doc = {}
					su_doc._id = db.space_users._makeNewID()
					su_doc.user = user_id
					su_doc.space = space_id
					su_doc.user_accepted =  true
					su_doc.invite_state = "accepted"

					if user
						su_doc.user_accepted = false
						su_doc.invite_state = "pending"

					# su_doc.user_accepted = true

					# if item.user_accepted == 0
					# 	su_doc.user_accepted = false

					su_doc.name = item.name
					if item.email
						su_doc.email = item.email
					su_doc.created = now
					su_doc.created_by = owner_id
					su_doc.organization = space_user_org_id
					su_doc.organizations = [su_doc.organization]

					if item.position
						su_doc.position = item.position

					if item.work_phone
						su_doc.work_phone = item.work_phone

					if item.phone
						su_doc.mobile = item.phone

					if item.sort_no
						su_doc.sort_no = item.sort_no

					if item.company
						su_doc.company = item.company

					space_user_id = db.space_users.direct.insert(su_doc)
					if space_user_id
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