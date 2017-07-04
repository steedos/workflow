Meteor.methods
	billing_recharge: (total_fee, space_id, module_id)->

		result_obj = {}

		attach = {}
		attach.space = space_id
		attach.module = module_id

		WXPay = require('weixin-pay')

		wxpay = WXPay({
			appid: 'xxxxxxxx',
			mch_id: '1234567890',
			# partner_key: 'xxxxxxxxxxxxxxxxx', #微信商户平台API密钥
			# pfx: fs.readFileSync('./wxpay_cert.p12') #微信商户平台证书
		})

		wxpay.createUnifiedOrder({
			body: '扫码支付测试',
			out_trade_no: moment().format('YYYYMMDDHHmmssSSS'),
			total_fee: total_fee,
			spbill_create_ip: '114.95.242.231',
			notify_url: Meteor.absolutUrl() + 'api/billing/recharge/notify',
			trade_type: 'NATIVE',
			product_id: '1234567890',
			attach: JSON.stringify(attach)
		}, (err, result) -> 
			console.log(result)
			result_obj = result
		)

		return result_obj