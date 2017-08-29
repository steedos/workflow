Template.space_recharge_modal.onRendered ()->
	$("#space_recharge_end_date").datetimepicker({
		format: "YYYY-MM-DD",
		locale: Session.get("TAPi18n::loaded_lang")
	})


Template.space_recharge_modal.helpers
	modules: ()->
		return db.modules.find()

	is_paid_module: (name)->
		s = db.spaces.findOne(Session.get('spaceId'))
		if s.modules and s.modules.includes(name)
			return true
		return false

	end_date: ()->
		m = moment()
		m.year(m.year()+1)
		e = m.format('YYYY-MM-DD')
		s = db.spaces.findOne(Session.get('spaceId'))
		if s.end_date
			e = moment(s.end_date).format('YYYY-MM-DD')

		return e


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
		now = moment.now()
		end_date = $('#space_recharge_end_date').val()
		modules = $('#space_recharge_modules input')
		
		user_count = $('#space_recharge_user_count')[0].value.to_integer()
		if module_id and months > 0 and user_count > 0
			module = db.modules.findOne(module_id)
			if module and module.listprice
				space_recharge_fee = module.listprice * (20/3) * user_count * months
				$('#space_recharge_fee')[0].value = space_recharge_fee.toFixed()
		else
			$('#space_recharge_fee')[0].value = ""

	'input #space_recharge_end_date,#space_recharge_user_count': (event, template)->
		modules = $('#space_recharge_modules input')
		end_date = $('#space_recharge_end_date').val()
		user_count = $('#space_recharge_user_count')[0].value.to_integer()
		if module_id and months > 0 and user_count > 0
			module = db.modules.findOne(module_id)
			if module and module.listprice
				space_recharge_fee = module.listprice * (20/3) * user_count * months
				$('#space_recharge_fee')[0].value = space_recharge_fee.toFixed()
		else
			$('#space_recharge_fee')[0].value = ""