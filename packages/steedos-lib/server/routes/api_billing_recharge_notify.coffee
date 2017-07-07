JsonRoutes.add 'post', '/api/billing/recharge/notify', (req, res, next) ->
	try
		console.log "===========/api/billing/recharge/notify=============="
		body = ""
		req.on('data', (chunk)->
			body += chunk
		)
		req.on('end', ()->
			console.log body
			xml2js = Npm.require('xml2js')
			parser = new xml2js.Parser({ trim:true, explicitArray:false, explicitRoot:false })
			parser.parseString(body, (err, result)->
				console.log JSON.stringify(result)
				# 特别提醒：商户系统对于支付结果通知的内容一定要做签名验证,并校验返回的订单金额是否与商户侧的订单金额一致，防止数据泄漏导致出现“假通知”，造成资金损失
				weixin_pay_code_url = db.weixin_pay_code_urls.findOne({'info.sing': result.sign})
				if weixin_pay_code_url && weixin_pay_code_url.total_fee is result.total_fee
					console.log "=="



			)
			
		)
		
	catch e
		console.error e.stack

	res.writeHead(200, {'Content-Type': 'application/xml'})
	res.end('<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>')

		