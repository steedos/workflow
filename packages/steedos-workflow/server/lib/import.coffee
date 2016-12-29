steedosImport = {}

#TODO 清理form无效的key
_remove_form_invalid_key = (form)->

#TODO 清理flow无效的key
_remove_flow_invalid_key = (flow)->


steedosImport.workflow = (uid, spaceId, jsonData)->
	console.log "--steedosImport.workflow--"
	try
		form = JSON.parse(jsonData)
	catch e
		console.log e;

	if _.isEmpty(form)
		throw  new Exception('无效的json data')

	new_form_ids = new Array()

	new_flow_ids = new Array()
	try
		if form?.category_name
			category = db.categories.findOne({space: spaceId, name: form.category_name}, {fields: {_id: 1}})

			if _.isEmpty(category)
				category_id = Meteor.uuid();
				db.categories.direct.insert({
					_id: category_id,
					name: form.category_name,
					space: spaceId,
					create: new Date,
					create_by: uid,
					modified: new Date,
					modified_by: uid
				});
				form.category = category_id
			else
				form.category = category._id

			delete form.category_name

		form_id = Meteor.uuid()

		#	form_version_id = Meteor.uuid()

		flows = form.flows

		delete form.flows

		form._id = form_id

		form.space = spaceId

		form.state = 'disabled' #设置状态为 未启用

		form.is_valid = false #设置已验证为 false

		form.create = new Date()

		form.create_by = uid

		form.historys = []

		#	form.current._id = form_version_id

		form.current._rev = 1 #重置版本号

		form.current.form = form_id

		form.current.create = new Date()

		form.current.create_by = uid

		form.current.modified = new Date()

		form.current.modified_by = uid

		form.import =true

		db.forms.direct.insert(form)

		new_form_ids.push(form_id)

		flows.forEach (flow)->
			flow_id = Meteor.uuid()

			flow._id = flow_id

			flow.form = form_id

			flow.space = spaceId

			flow.state = 'disabled'

			flow.is_valid = false

			flow.current_no = 0 #重置编号起始为0

			flow.create = new Date()

			flow.create_by = uid

			#		设置提交部门为：全公司
			perms = {
				_id: Meteor.uuid()
				users_can_add: []
				orgs_can_add: db.organizations.find({
					space: spaceId,
					is_company: true
				}, {fields: {_id: 1}}).fetch().getProperty("_id")
				users_can_monitor: []
				orgs_can_monitor: []
				users_can_admin: []
				orgs_can_admin: []
			}

			flow.perms = perms

			flow.current.flow = flow_id

			flow.current._rev = 1 #重置版本

			flow.current.form_version = form.current._id

			flow.current.create = new Date()

			flow.current.create_by = uid

			flow.current.modified = new Date()

			flow.current.modified_by = uid

			flow.current?.steps.forEach (step)->
				if _.isEmpty(step.approver_roles_name)
					delete step.approver_roles_name
					step.approver_roles = []
				else
					approve_roles = new Array()
					step.approve_roles_name.forEach (role_name) ->
						role = db.flow_roles.findOne({space: spaceId, name: role_name}, {fields: {_id: 1}})
						if _.isEmpty(role)
							role_id = db.flow_roles._makeNewID()
							role = {
								_id: role_id
								name: role_name
								space: spaceId
								create: new Date
								create_by: uid
							}

							db.flow_roles.direct.insert(role)

							approve_roles.push(role_id)
						else
							approve_roles.push(role_id)

					step.approve_roles = approve_roles

					delete step.approve_roles_name

			flow.import =true

			db.flows.direct.insert(flow)

			new_flow_ids.push(flow_id)
	catch e
		new_form_ids.forEach (id)->
			db.forms.direct.remove(id)

		new_flow_ids.forEach (id)->
			db.flows.direct.remove(id)
		throw  e





