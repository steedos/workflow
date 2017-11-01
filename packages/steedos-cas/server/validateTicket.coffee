xml2js = require 'xml2js'
Cookies = Npm.require("cookies")

Meteor.startup ->
	JsonRoutes.add 'get', '/steedos/cas', (req, res, next) ->
		cookies = new Cookies( req, res );

		ticket = req?.query?.ticket
		service_url = "http://192.168.0.81:3000/steedos/cas/"
		cas_url = "http://localhost:8086/cas"
		validate_url = cas_url + "/serviceValidate?service=" + service_url + "&ticket=" + ticket

		result = HTTP.call('GET',validate_url)
		netError = result.statusCode
		console.log 
		if netError!=200
			return
		parser = new xml2js.Parser()
		parser.parseString result.content, (err, result) ->
			failuer = result?["cas:serviceResponse"]?["cas:authenticationFailure"]
			success = result?["cas:serviceResponse"]?["cas:authenticationSuccess"]
			if failuer
				console.log "失败"
				return
			username = success?[0]?["cas:user"]?[0]
			# 验证成功了，取到了username的值，怎么登陆steedos?
			user = Meteor.users.findOne "username": username
			console.log user

			authToken = Accounts._generateStampedLoginToken()
			token = authToken.token
			hashedToken = Accounts._hashStampedToken authToken
			# if app_id and client_id
			# 	hashedToken.app_id = app_id
			# 	hashedToken.client_id = client_id

			# hashedToken.token = token

			Accounts._insertHashedLoginToken user._id, hashedToken
			Setup.setAuthCookies(req, res, user._id, token)

			res.writeHead(301, {'Location': '/'});

			res.end();

			# JsonRoutes.sendResult res, 
			# 	data: 
			# 		userId: user._id
			# 		authToken: token
			# 		apps: []
			# 		dsInfo: 
			# 			dsid: user._id
			# 			steedosId: user.steedos_id
			# 			name: user.name
			# 			primaryEmail: user.email
			# 			statusCode: 2
			# 		instance: "1329598861"
			# 		isExtendedLogin: true
			# 		requestInfo:
			# 			country: "CN"
			# 			region: "SH"
			# 			timezone: "GMT+8"
			# 		webservices:
			# 			Steedos.settings.webservices


			console.log 'Done.'
		return
