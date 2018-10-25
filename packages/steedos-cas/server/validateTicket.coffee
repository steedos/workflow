xml2js = require 'xml2js'
Cookies = Npm.require("cookies")

Meteor.startup ->
	JsonRoutes.add 'get', '/api/cas/sso', (req, res, next) ->
		try
		
			cas_url = Meteor.settings?.public?.webservices?.cas?.url

			cookies = new Cookies( req, res )

			ticket = req?.query?.ticket

			redirect_url = req?.query?.redirect_url

			service_url = Meteor.absoluteUrl('api/cas/sso')

			if redirect_url
				service_url = service_url + "?redirect_url=" + redirect_url

			validate_url = cas_url + "/serviceValidate?service=" + service_url + "&ticket=" + ticket

			result = HTTP.call('GET',validate_url)

			netError = result.statusCode

			if netError != 200
				throw new Meteor.Error "cas network is disconnected"

			parser = new xml2js.Parser()

			parser.parseString result.content, (err, result) ->
				failure = result?["cas:serviceResponse"]?["cas:authenticationFailure"]

				success = result?["cas:serviceResponse"]?["cas:authenticationSuccess"]

				if failure
					console.error failure
					throw new Meteor.Error 'cas authentication failure'

				username = success?[0]?["cas:user"]?[0]

				console.log "username",username

				# 验证成功了，取到了username的值，怎么登陆steedos?

				user = Meteor.users.findOne "username": username

				if not user
					throw new Meteor.Error "user(#{username}) not found"

				authToken = Accounts._generateStampedLoginToken()

				token = authToken.token

				hashedToken = Accounts._hashStampedToken authToken

				Accounts._insertHashedLoginToken user._id, hashedToken

				Setup.setAuthCookies(req, res, user._id, token)

				if redirect_url
					res.writeHead(301, {'Location': redirect_url})
				else
					res.writeHead(301, {'Location': '/'})

				res.end()
			return
		catch e
			console.error e.stack
			JsonRoutes.sendResult res,
				code: 200
				data: { errors: [{errorMessage: e.error || e.message}] }