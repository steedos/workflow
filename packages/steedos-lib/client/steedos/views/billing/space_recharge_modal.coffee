Template.space_recharge_modal.helpers
	modules: ()->
		return db.modules.find()


Template.space_recharge_modal.events
	'click #space_recharge_generate_qrcode': (event, template)->
		select = document.getElementById('space_recharge_modules')
		module_name = select.options[select.selectedIndex].text
		new_id = db.weixin_pay_code_urls._makeNewID()
		fee_value = $('#space_recharge_fee')[0].value.to_integer()
		if fee_value <= 0
			$('#space_recharge_fee')[0].value = ""
			return
		total_fee = 100 * fee_value


		$("body").addClass("loading")
		Meteor.call 'billing_recharge', total_fee, Session.get('spaceId'), $('#space_recharge_modules').val(), new_id, module_name, (err, result)->
			if err
				console.log err
			if result
				console.log result
				data = new Object
				data.app = 'workflow.prefessional'
				data._id = new_id
				Modal.allowMultiple = true
				Modal.show('space_recharge_qrcode_modal', data)