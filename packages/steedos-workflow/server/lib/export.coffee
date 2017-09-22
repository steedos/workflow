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

			step.approver_orgs = []
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


###
    获取form对象

    category: form的分组名次

    form：不包含历史版本

    instance_number_rules: 表单字段所引用的编号规则

    flows: 引用此表单的所有流程，不包含历史版本
###
steedosExport.form = (formId) ->
	form = db.forms.findOne({_id: formId}, {fields: {historys: 0}});

	if !form
		return {}

	form.historys = []

	if form?.category
		category = db.categories.findOne({_id: form.category}, {fields: {name: 1}});

		if category?.name
			form.category_name = category.name



	_getNumberRuleName = (str)->
		if str?.indexOf("auto_number(") > -1
			str = str.replace("auto_number(", "").replace(")", "").replace("\"", "").replace("\"", "").replace("\'", "").replace("\'", "")
			return str
		return ;

	instance_number_rules = new Array()

	if form.current

		fields = new Array()

		c_fields = form.current.fields

		c_fields.forEach (f)->
			if f.type == 'table'
				console.log 'ignore table field'
			else if f.type == 'section'
				f?.fields?.forEach (f1)->
					fields.push f1
			else
				fields.push f

		_getFieldNumberRule = (spaceId, instance_number_rules, str)->
			number_rule_name = _getNumberRuleName(str)

			if number_rule_name
				number_rule = db.instance_number_rules.findOne({space: spaceId, name: number_rule_name}, {fields: {_id: 1, name: 1, year: 1, first_number: 1, rules: 1}})

				number_rule.number = 0

				if !instance_number_rules.findPropertyByPK("_id", number_rule._id)

					delete number_rule._id

					instance_number_rules.push(number_rule)

			return instance_number_rules


		fields.forEach (f)->
			_getFieldNumberRule(form.space, instance_number_rules, f.default_value)

			_getFieldNumberRule(form.space, instance_number_rules, f.formula)

	form.instance_number_rules = instance_number_rules

	form.flows = _getFlowByForm(formId)

	return form