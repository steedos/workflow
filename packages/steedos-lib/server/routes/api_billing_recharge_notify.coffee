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
			)
			
		)
		
	catch e
		console.error e.stack

	res.writeHead(200, {'Content-Type': 'application/xml'})
	res.end('<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>')

		