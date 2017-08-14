Template.space_recharge_modal.helpers
	modules: ()->
		return db.modules.find()


Template.space_recharge_modal.events
	'click #space_recharge_generate_qrcode': (event, template)->
		select = document.getElementById('space_recharge_modules')
		module_name = select.options[select.selectedIndex].text
		new_id = db.billing_pay_records._makeNewID()

		fee_value = 0
		module_id = $('#space_recharge_modules')[0].value
		months = $('#space_recharge_months')[0].value.to_integer()
		user_count = $('#space_recharge_user_count')[0].value.to_integer()
		if module_id and months > 0 and user_count > 0
			module = db.modules.findOne(module_id)
			if module and module.listprice
				fee_value = module.listprice * (20/3) * user_count * months
		else
			return

		if fee_value <= 0
			$('#space_recharge_fee')[0].value = ""
			return
		total_fee = 100 * fee_value

		$("body").addClass("loading")
		Meteor.call 'billing_recharge', total_fee, Session.get('spaceId'), $('#space_recharge_modules').val(), new_id, module_name, (err, result)->
			if err
				$("body").removeClass("loading")
				console.log err
				toastr.error(err.reason)
			if result
				data = new Object
				data.app = 'workflow.prefessional'
				data._id = new_id
				Modal.allowMultiple = true
				Modal.show('space_recharge_qrcode_modal', data)

	'change #space_recharge_modules': (event, template)->
		module_id = $('#space_recharge_modules')[0].value
		months = $('#space_recharge_months')[0].value.to_integer()
		user_count = $('#space_recharge_user_count')[0].value.to_integer()
		if module_id and months > 0 and user_count > 0
			module = db.modules.findOne(module_id)
			if module and module.listprice
				space_recharge_fee = module.listprice * (20/3) * user_count * months
				$('#space_recharge_fee')[0].value = space_recharge_fee.toFixed()
		else
			$('#space_recharge_fee')[0].value = ""

	'input #space_recharge_months,#space_recharge_user_count': (event, template)->
		module_id = $('#space_recharge_modules')[0].value
		months = $('#space_recharge_months')[0].value.to_integer()
		user_count = $('#space_recharge_user_count')[0].value.to_integer()
		if module_id and months > 0 and user_count > 0
			module = db.modules.findOne(module_id)
			if module and module.listprice
				space_recharge_fee = module.listprice * (20/3) * user_count * months
				$('#space_recharge_fee')[0].value = space_recharge_fee.toFixed()
		else
			$('#space_recharge_fee')[0].value = ""