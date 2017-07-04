Template.space_recharge_modal.helpers
	modules: ()->
		return db.modules.find()


Template.space_recharge_modal.events
	'click #space_recharge_generate_qrcode': (event, template)->
		
		total_fee = 1 
		Meteor.call billing_recharge, total_fee, Session.get('spaceId'), $('#space_recharge_modules').val(), (err, result)->
			if err
				console.log result
			if result
				console.log result
		data = new Object
		data.app = 'workflow.prefessional'
		Modal.allowMultiple = true
		Modal.show('space_recharge_qrcode_modal', data)