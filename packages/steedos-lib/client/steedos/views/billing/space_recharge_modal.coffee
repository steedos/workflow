Template.space_recharge_modal.helpers
	modules: ()->
		return db.modules.find()


Template.space_recharge_modal.events
	'click #space_recharge_generate_qrcode': (event, template)->
		# WXPay = require('weixin-pay')

		# wxpay = WXPay({
		# 	appid: 'xxxxxxxx',
		# 	mch_id: '1234567890',
		# 	partner_key: 'xxxxxxxxxxxxxxxxx', #微信商户平台API密钥
		# 	pfx: fs.readFileSync('./wxpay_cert.p12'), #微信商户平台证书
		# })

		# wxpay.createUnifiedOrder({
		# 	body: '扫码支付测试',
		# 	out_trade_no: moment().format('YYYYMMDDHHmmssSSS'),
		# 	total_fee: 1,
		# 	spbill_create_ip: '192.168.2.210',
		# 	notify_url: 'http://wxpay_notify_url',
		# 	trade_type: 'NATIVE',
		# 	product_id: '1234567890'
		# }, (err, result) -> 
		# 	console.log(result)
		# )
		data = new Object
		data.app = 'workflow.prefessional'
		Modal.allowMultiple = true
		Modal.show('space_recharge_qrcode_modal', data)