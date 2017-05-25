Template.instance_cc_modal.helpers
	fields: ->
		form_version = WorkflowManager.getInstanceFormVersion()
		currentStep = InstanceManager.getCurrentStep()
		currentApprove = InstanceManager.getCurrentApprove()
		opinionFields = _.filter(form_version.fields, (field) ->
			if currentApprove.type == 'cc'
				return InstanceformTemplate.helpers.isOpinionField(field) and field.code == currentApprove.opinion_field_code
			InstanceformTemplate.helpers.isOpinionField(field) and InstanceformTemplate.helpers.getOpinionFieldStepsName(field.formula).filterProperty('stepName', currentStep.name).length > 0
		)
		modalFields = cc_users:
			autoform:
				type: 'selectuser'
				multiple: true,
				is_within_user_organizations: Meteor.settings?.public?.workflow?.cc_selection_within_user_organizations || false
			optional: false
			type: [ String ]
			label: TAPi18n.__('instance_cc_user')
		if opinionFields.length > 0
			modalFields.opinion_field =
				autoform: type: 'select'
				type: String
				label: TAPi18n.__('instance_opinion_field')
			options = new Array
			opinionFields.forEach (field) ->
				label = field.name || field.code
				options.push
					label: label
					value: field.code
				return
			modalFields.opinion_field.autoform.options = options
			if options.length == 1
				modalFields.opinion_field.autoform.defaultValue = options[0].value
		new SimpleSchema(modalFields)
	values: ->
		{}
	showOpinionFields: (fields) ->
		if fields.schema('opinion_field')
			return true
		false
Template.instance_cc_modal.events
	'show.bs.modal #instance_cc_modal': (event) ->
		cc_users = $('input[name=\'cc_users\']', $('#instance_cc_modal'))[0]
		cc_users.value = ''
		cc_users.dataset.values = ''
		s = InstanceManager.getCurrentStep()
		$('#instance_curstepName', $('#instance_cc_modal')).html s.name
		return
	'click #cc_help': (event, template) ->
		Steedos.openWindow t('cc_help')
		return
	'click #cc_modal_ok': (event, template) ->
		val = AutoForm.getFieldValue('cc_users', 'instanceCCForm')
		if !val or val.length < 1
			toastr.error TAPi18n.__('instance_cc_error_users_required')
			return
		opinion_field_code = AutoForm.getFieldValue('opinion_field', 'instanceCCForm')
		if AutoForm.getFormSchema('instanceCCForm').schema('opinion_field')
			if !opinion_field_code or opinion_field_code.length < 1
				toastr.error TAPi18n.__('instance_cc_error_opinion_field_required')
				return
		$('#cc_modal_ok').attr 'disabled', true
		$('#cc_modal_ok').html '<i class=\'ion ion-load-c fa-spin\'></i>'
		#调用cc 接口。
		instance = WorkflowManager.getInstance()
		myApprove = undefined
		if InstanceManager.isCC(instance)
			myApprove = InstanceManager.getCCApprove(Meteor.userId(), false)
		else
			myApprove = InstanceManager.getMyApprove()
			myApprove.values = InstanceManager.getInstanceValuesByAutoForm()
			if instance.attachments and myApprove
				myApprove.attachments = instance.attachments
		myApprove.opinion_field_code = opinion_field_code
		Meteor.call 'cc_do', myApprove, val, (error, result) ->
			WorkflowManager.instanceModified.set false
			if error
				Modal.hide template
				toastr.error 'error'
			if result == true
				toastr.success t('instance_cc_done')
				Modal.hide template
			return
		return
