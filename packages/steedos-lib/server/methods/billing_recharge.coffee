Meteor.methods
	billing_recharge: (total_fee, space_id, module_id, new_id, module_name)->
		check total_fee, Number
		check space_id, String 
		check module_id, String 
		check new_id, String 
		check module_name, String 

		user_id = this.userId

		result_obj = {}

		attach = {}
		attach.space = space_id
		attach.module = module_id
		attach.code_url_id = new_id
		WXPay = Npm.require('weixin-pay')

		wxpay = WXPay({
			appid: Meteor.settings.billing.appid,
			mch_id: Meteor.settings.billing.mch_id,
			partner_key: Meteor.settings.billing.partner_key #微信商户平台API密钥
		})

		wxpay.createUnifiedOrder({
			body: module_name,
			out_trade_no: moment().format('YYYYMMDDHHmmssSSS'),
			total_fee: total_fee,
			spbill_create_ip: '114.95.242.231',
			notify_url: Meteor.absoluteUrl() + 'api/billing/recharge/notify',
			trade_type: 'NATIVE',
			product_id: module_id,
			attach: JSON.stringify(attach)
		}, Meteor.bindEnvironment(((err, result) -> 
				obj = {}
				obj._id = new_id
				obj.created = new Date
				obj.info = result
				obj.total_fee = total_fee
				obj.created_by = user_id
				db.weixin_pay_code_urls.insert(obj)
			), ()->
				console.log 'Failed to bind environment'
			)
		)

		
		return "success"