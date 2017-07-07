Meteor.methods
	billing_recharge: (total_fee, space_id, module_id, new_id, module_name)->
		check total_fee, Number
		check space_id, String 
		check module_id, String 
		check new_id, String 
		check module_name, String 

		result_obj = {}

		attach = {}
		attach.space = space_id
		attach.module = module_id

		WXPay = Npm.require('weixin-pay')

		wxpay = WXPay({
			appid: 'wxe130bd795323d524',
			mch_id: '1484705002'
			partner_key: '5194c66ef4a563537a0000035194c66e' #微信商户平台API密钥
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
				console.log "-----createUnifiedOrder----"
				console.log(result)
				obj = {}
				obj._id = new_id
				obj.created = new Date
				obj.info = result
				obj.total_fee = total_fee
				db.weixin_pay_code_urls.insert(obj)
			), ()->
				console.log 'Failed to bind environment'
			)
		)

		
		return "success"