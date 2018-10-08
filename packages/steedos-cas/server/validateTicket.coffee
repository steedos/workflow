xml2js = require 'xml2js'
Cookies = Npm.require("cookies")

Meteor.startup ->
	JsonRoutes.add 'get', '/api/cas/sso', (req, res, next) ->

		cookies = new Cookies( req, res )

		ticket = req?.query?.ticket

		service_url = Meteor.absoluteUrl('api/cas/sso')

		cas_url = Meteor.settings?.public?.webservices?.cas?.url

		validate_url = cas_url + "/serviceValidate?service=" + service_url + "&ticket=" + ticket

		result = HTTP.call('GET',validate_url)

		netError = result.statusCode

		if netError!=200
			console.error "cas network is disconnected"
			return

		parser = new xml2js.Parser()

		parser.parseString result.content, (err, result) ->
			failure = result?["cas:serviceResponse"]?["cas:authenticationFailure"]

			success = result?["cas:serviceResponse"]?["cas:authenticationSuccess"]

			if failure
				console.error "cas authentication failure"
				console.error failure
				return

			username = success?[0]?["cas:user"]?[0]

			# 验证成功了，取到了username的值，怎么登陆steedos?

			user = Meteor.users.findOne "username": username

			authToken = Accounts._generateStampedLoginToken()

			token = authToken.token

			hashedToken = Accounts._hashStampedToken authToken

			Accounts._insertHashedLoginToken user._id, hashedToken

			Setup.setAuthCookies(req, res, user._id, token)

			res.writeHead(301, {'Location': '/'});

			res.end();
		return
