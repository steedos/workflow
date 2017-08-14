Meteor.methods
	billing_recharge: (total_fee, space_id, module_id, new_id, module_name)->
		check total_fee, Number
		check space_id, String 
		check module_id, String 
		check new_id, String 
		check module_name, String 

		user_id = this.userId

		module = db.modules.findOne(module_id)
		space_user_count = db.space_users.find({space:space_id}).count()
		one_month_yuan = space_user_count * (module.listprice*20/3)
		if total_fee < one_month_yuan*100
			throw new Meteor.Error 'error!', "充值金额应不少于一个月所需费用：￥#{one_month_yuan}"

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
			spbill_create_ip: '123.56.251.18',
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
				obj.space = space_id
				obj.paid = false
				db.billing_pay_records.insert(obj)
			), ()->
				console.log 'Failed to bind environment'
			)
		)

		
		return "success"