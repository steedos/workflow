Template.accounts_admin_register.helpers
	errors: ->
		return Template.instance().errors.get()


Template.accounts_admin_register.onCreated ->
	this.errors = new ReactiveVar({})


Template.accounts_admin_register.onRendered ->

Template.accounts_admin_register.events
	'click .btn-save': (event,template) ->

	'change .form-company': (event,template) ->
		val = $(event.currentTarget).val()
		errors = template.errors.get()
		if val
			delete errors.company
			template.errors.set(errors)
		else
			errors.company = "不能为空"
			template.errors.set(errors)

	'change .form-email': (event,template) ->
		val = $(event.currentTarget).val()
		errors = template.errors.get()
		if val
			delete errors.email
			template.errors.set(errors)
		else
			errors.email = "不能为空"
			template.errors.set(errors)

	'change .form-name': (event,template) ->
		val = $(event.currentTarget).val()
		errors = template.errors.get()
		if val
			delete errors.name
			template.errors.set(errors)
		else
			errors.name = "不能为空"
			template.errors.set(errors)




