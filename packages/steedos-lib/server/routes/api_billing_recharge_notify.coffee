JsonRoutes.add 'post', '/api/billing/recharge/notify', (req, res, next) ->
	try
		console.log "===========/api/billing/recharge/notify=============="
		body = ""
		req.on('data', (chunk)->
			body += chunk
		)
		req.on('end', Meteor.bindEnvironment((()->
				console.log body
				xml2js = Npm.require('xml2js')
				parser = new xml2js.Parser({ trim:true, explicitArray:false, explicitRoot:false })
				parser.parseString(body, (err, result)->
						# 特别提醒：商户系统对于支付结果通知的内容一定要做签名验证,并校验返回的订单金额是否与商户侧的订单金额一致，防止数据泄漏导致出现“假通知”，造成资金损失
						WXPay = Npm.require('weixin-pay')
						wxpay = WXPay({
							appid: 'wxe130bd795323d524',
							mch_id: '1484705002'
							partner_key: '5194c66ef4a563537a0000035194c66e' #微信商户平台API密钥
						})
						sign = wxpay.sign(_.clone(result))
						attach = JSON.parse(result.attach)
						weixin_pay_code_url = db.weixin_pay_code_urls.findOne(attach.code_url_id)
						console.log(weixin_pay_code_url.total_fee is Number(result.total_fee))
						console.log(sign is result.sign)
						if weixin_pay_code_url and weixin_pay_code_url.total_fee is Number(result.total_fee) and sign is result.sign
							if attach.space and attach.module and result.total_fee
								billingManager.special_pay(attach.space, attach.module, Number(result.total_fee), weixin_pay_code_url.created_by)
					
				)
			), (err)->
				console.error err.stack
				console.log 'Failed to bind environment'
			)
		)
		
	catch e
		console.error e.stack

	res.writeHead(200, {'Content-Type': 'application/xml'})
	res.end('<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>')

		