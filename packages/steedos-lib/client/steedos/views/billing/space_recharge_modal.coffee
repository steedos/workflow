Template.space_recharge_modal.helpers
	modules: ()->
		return db.modules.find()


Template.space_recharge_modal.events
	'click #space_recharge_generate_qrcode': (event, template)->
		data = new Object
		data.app = 'workflow.prefessional'
		Modal.allowMultiple = true
		Modal.show('space_recharge_qrcode_modal', data)