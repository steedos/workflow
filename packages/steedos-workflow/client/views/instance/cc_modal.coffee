Template.instance_cc_modal.helpers
	fields: ->
		form_version = WorkflowManager.getInstanceFormVersion()
		currentStep = InstanceManager.getCurrentStep()
		ins = WorkflowManager.getInstance()
		if InstanceManager.isInbox() && ins.state is "pending" 
			currentApprove = InstanceManager.getCurrentApprove()
		else
			currentApprove = InstanceManager.getLastApprove(ins.traces)

		if !currentApprove
			return

		canCC = (formula, currentStep)->
			formulas = InstanceformTemplate.helpers.getOpinionFieldStepsName(formula)

			rev = false;

			formulas.forEach (f)->
				if !f.only_handler && f.stepName == currentStep.name
					rev = true
			return rev;


		opinionFields = _.filter(form_version.fields, (field) ->
			if currentApprove.type == 'cc'
				return InstanceformTemplate.helpers.isOpinionField(field) and _.indexOf(currentApprove.opinion_fields_code, field.code) > -1 and canCC(field.formula, currentStep)
			InstanceformTemplate.helpers.isOpinionField(field) and InstanceformTemplate.helpers.getOpinionFieldStepsName(field.formula).filterProperty('stepName', currentStep.name).length > 0 and canCC(field.formula, currentStep)
		)
		modalFields = 
			cc_users:
				autoform:
					type: 'selectuser'
					multiple: true,
					is_within_user_organizations: Meteor.settings?.public?.workflow?.user_selection_within_user_organizations || false
				optional: false
				type: [ String ]
				label: TAPi18n.__('instance_cc_user')
			
			cc_description:
				type: String,
				optional: true,
				autoform:
					type:'coreform-textarea'
				label: TAPi18n.__('instance_cc_description')

		if opinionFields.length > 0
			modalFields.opinion_fields =
				autoform: type: 'coreform-multiSelect'
				type: [String]
				label: TAPi18n.__('instance_opinion_field')
				optional: true
			options = new Array
			opinionFields.forEach (field) ->
				label = field.name || field.code
				options.push
					label: label
					value: field.code
				return

			modalFields.opinion_fields.autoform.defaultValue = options.getProperty("value") || []

			modalFields.opinion_fields.autoform.options = options
			if options.length == 1
				modalFields.opinion_fields.autoform.defaultValue = options[0].value
		new SimpleSchema(modalFields)
	values: ->
		{}
	showOpinionFields: (fields) ->
		if fields.schema('opinion_fields')
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
		description = AutoForm.getFieldValue('cc_description', 'instanceCCForm') || ""
		if !val or val.length < 1
			toastr.error TAPi18n.__('instance_cc_error_users_required')
			return
		opinion_fields_code = AutoForm.getFieldValue('opinion_fields', 'instanceCCForm')  || []
#		if AutoForm.getFormSchema('instanceCCForm').schema('opinion_fields')
#			if !opinion_fields_code or opinion_fields_code.length < 1
#				toastr.error TAPi18n.__('instance_cc_error_opinion_field_required')
#				return
		$('#cc_modal_ok').attr 'disabled', true
		$('#cc_modal_ok').html '<i class=\'ion ion-load-c fa-spin\'></i>'
		#调用cc 接口。
		instance = WorkflowManager.getInstance()
		myApprove = undefined
		if InstanceManager.isCC(instance)
			myApprove = InstanceManager.getCCApprove(Meteor.userId(), false)
		else
			ins = WorkflowManager.getInstance()
			if InstanceManager.isInbox() && ins.state is "pending" 
				myApprove = InstanceManager.getMyApprove()
				myApprove.values = InstanceManager.getInstanceValuesByAutoForm()
				if instance.attachments and myApprove
					myApprove.attachments = instance.attachments
			else
				myApprove = InstanceManager.getLastApprove(ins.traces)
				
		myApprove.opinion_fields_code = opinion_fields_code
		Meteor.call 'cc_do', myApprove, val, description, (error, result) ->
			WorkflowManager.instanceModified.set false
			if error
				Modal.hide template
				toastr.error 'error'
			if result == true
				toastr.success t('instance_cc_done')
				Modal.hide template
			return
		return
