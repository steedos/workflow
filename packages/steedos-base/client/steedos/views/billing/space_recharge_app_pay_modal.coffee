Template.space_recharge_app_pay_modal.helpers


Template.space_recharge_app_pay_modal.events
	'click #space_recharge_app_pay_btn': (event, template)->
		console.log this
		bpr = db.billing_pay_records.findOne({_id: this._id})
		console.log bpr
		if bpr and wxpay
			wxpay.payment(bpr.app_pay_sign,
				()->
					console.log "wxpay.payment called success"
				, (e)->
					console.error "wxpay.payment called failed"
					console.error e
			)



Template.space_recharge_app_pay_modal.onRendered ()->
	that = this
	code_url_id = that.data._id
	db.billing_pay_records.find({_id: code_url_id}).observe({
		added: (doc)->
			$("body").removeClass("loading")
		,
		changed: (newDoc, oldDoc)->
			if oldDoc.paid is false and newDoc.paid is true
				Modal.hide()
				$('#space_recharge_modal')?.modal('hide')
				swal({title:'充值成功！', confirmButtonText: t("OK"), type: 'success'})

	})
	Meteor.subscribe 'billing_weixin_pay_code_url', code_url_id
