steedosImport = {}

steedosImport.workflow = (uid, spaceId, form, enabled)->

	if _.isEmpty(form)
		throw  new Exception('无效的json data')

	new_form_ids = new Array()

	new_flow_ids = new Array()
	try
		if form?.category_name
			category = db.categories.findOne({space: spaceId, name: form.category_name}, {fields: {_id: 1}})

			if _.isEmpty(category)
				category_id = new Mongo.ObjectID()._str;
				db.categories.direct.insert({
					_id: category_id,
					name: form.category_name,
					space: spaceId,
					created: new Date,
					created_by: uid,
					modified: new Date,
					modified_by: uid
				});
				form.category = category_id
			else
				form.category = category._id

			delete form.category_name

		if form?.instance_number_rules
			form.instance_number_rules.forEach (nr)->
				try
					rules = db.instance_number_rules.findOne({space: spaceId, "name": nr.name})

					if !rules
						nr.space = spaceId
						nr._id = new Mongo.ObjectID()._str
						db.instance_number_rules.direct.insert(nr)
				catch e
					console.log "steedosImport.workflow", e

			delete form.instance_number_rules

		form_id = new Mongo.ObjectID()._str

		flows = form.flows

		delete form.flows

		form._id = form_id

		form.space = spaceId
		if enabled
			form.state = 'enabled'
		else
			form.state = 'disabled' #设置状态为 未启用

		form.is_valid = false #设置已验证为 false

		form.created = new Date()

		form.created_by = uid

		form.historys = []

		form.current._id = new Mongo.ObjectID()._str

		form.current._rev = 1 #重置版本号

		form.current.form = form_id

		form.current.created = new Date()

		form.current.created_by = uid

		form.current.modified = new Date()

		form.current.modified_by = uid

		form.import = true

		db.forms.direct.insert(form)



		new_form_ids.push(form_id)

		flows.forEach (flow)->
			flow_id = new Mongo.ObjectID()._str

			flow._id = flow_id

			flow.form = form_id

			flow.space = spaceId

			if enabled
				flow.state = 'enabled'
			else
				flow.state = 'disabled' #设置状态为 未启用

			flow.is_valid = false

			flow.current_no = 0 #重置编号起始为0

			flow.created = new Date()

			flow.created_by = uid

			if !flow.perms
				#设置提交部门为：全公司
				perms = {
					_id: new Mongo.ObjectID()._str
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

			flow.current._id = new Mongo.ObjectID()._str

			flow.current.flow = flow_id

			flow.current._rev = 1 #重置版本

			flow.current.form_version = form.current._id

			flow.current.created = new Date()

			flow.current.created_by = uid

			flow.current.modified = new Date()

			flow.current.modified_by = uid

			flow.current?.steps.forEach (step)->
				if _.isEmpty(step.approver_roles_name)
					delete step.approver_roles_name
					if _.isEmpty(step.approver_roles)
						step.approver_roles = []
				else
					approve_roles = new Array()
					step.approver_roles_name.forEach (role_name) ->
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
							approve_roles.push(role._id)

					step.approver_roles = approve_roles

					delete step.approver_roles_name

			flow.import = true

			db.flows.direct.insert(flow)

			new_flow_ids.push(flow_id)
	catch e
		new_form_ids.forEach (id)->
			db.forms.direct.remove(id)

		new_flow_ids.forEach (id)->
			db.flows.direct.remove(id)
		throw  e





