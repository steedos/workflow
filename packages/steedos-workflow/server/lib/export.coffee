steedosExport = {}

_getFlowByForm = (form)->
	flows = db.flows.find({form: form}, {fields: {historys: 0, perms: 0}}).fetch();

	flows.forEach (flow) ->
		flow.historys = []
		flow.current.steps?.forEach (step) ->
			roles_name = []
			if !_.isEmpty(step.approver_roles)
				roles_name = db.flow_roles.find({_id: {$in: step.approver_roles}}, {fields: {name: 1}}).fetch().getProperty("name");

			step.approver_roles_name = roles_name

			step.approver_users = []

			step.approve_orgs = []
	#			users_name = []
	#			if !_.isEmpty(step.approver_users)
	#				users_name = db.users.find({_id: {$in: step.approver_users}}, {fields: {steedos_id : 1}}).fetch().getProperty("steedos_id");
	#
	#			step.approver_users_name = users_name
	#
	#			orgs_fullname = []
	#			if !_.isEmpty(step.approver_orgs)
	#				orgs_fullname = db.organizations.find({_id: {$in: step.approver_orgs}}, {fields: {fullname : 1}}).fetch().getProperty("fullname");
	#
	#			step.approver_orgs_fullname = orgs_fullname

	return flows;


steedosExport.form = (formId) ->
	form = db.forms.findOne({_id: formId}, {fields: {historys: 0}});

	if !form
		return {}

	form.historys = []

	if form?.category
		category = db.categories.findOne({_id: form.category}, {fields: {name: 1}});

		if category?.name
			form.category_name = category.name

	form.flows = _getFlowByForm(formId)

	return form