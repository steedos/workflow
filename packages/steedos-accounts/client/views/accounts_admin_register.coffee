Template.accounts_admin_register.helpers
	errors: ->
		return Template.instance().errors.get()


Template.accounts_admin_register.onCreated ->
	this.errors = new ReactiveVar({})


Template.accounts_admin_register.onRendered ->

Template.accounts_admin_register.events
	'click .btn-save': (event,template) ->
		$(".weui-input").trigger("change")

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
			reg = /.+@(.+){2,}\.(.+){2,}/
			unless reg.test val
				errors.email = t 'Invalid email'
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

	'change .form-password': (event,template) ->
		val = $(event.currentTarget).val()
		errors = template.errors.get()
		if val
			delete errors.password
			result = Steedos.validatePassword val
			if result.error
				errors.password = result.error.reason
			template.errors.set(errors)
		else
			errors.password = "不能为空"
			template.errors.set(errors)

	'change .form-confirmpwd': (event,template) ->
		val = $(event.currentTarget).val()
		errors = template.errors.get()
		if val
			delete errors.confirmpwd
			unless val == $(".form-password").val()
				errors.confirmpwd = "两次密码不一致"
			template.errors.set(errors)
		else
			errors.confirmpwd = "不能为空"
			template.errors.set(errors)



