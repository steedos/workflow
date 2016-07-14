crypto = Npm.require('crypto')
Cookies = Npm.require("cookies")

JsonRoutes.add "get", "/api/setup/sso/:app_id", (req, res, next) ->

	app = db.apps.findOne(req.params.app_id)
	if app
		secret = app.secret
		redirectUrl = app.url
	else
		secret = "-8762-fcb369b2e8"
		redirectUrl = req.params.redirectUrl

	if !redirectUrl
		res.writeHead 401
		res.end()
		return

	cookies = new Cookies( req, res );

	# first check request body
	if req.body
		userId = req.body["X-User-Id"]
		authToken = req.body["X-Auth-Token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if !userId and !authToken
		userId = req.query["X-User-Id"]
		authToken = req.query["X-Auth-Token"]

	if userId and authToken
		hashedToken = Accounts._hashLoginToken(authToken)
		user = Meteor.users.findOne
			_id: userId,
			"services.resume.loginTokens.hashedToken": hashedToken
		if user
			steedos_id = user.steedos_id
			if app.secret
				iv = app.secret
			else
				iv = "-8762-fcb369b2e8"
			now = parseInt(new Date().getTime()/1000).toString()
			key32 = ""
			len = steedos_id.length
			if len < 32
				c = ""
				i = 0
				m = 32 - len
				while i < m
					c = " " + c
					i++
				key32 = steedos_id + c
			else if len >= 32
				key32 = steedos_id.slice(0,32)

			cipher = crypto.createCipheriv('aes-256-cbc', new Buffer(key32, 'utf8'), new Buffer(iv, 'utf8'))

			cipheredMsg = Buffer.concat([cipher.update(new Buffer(now, 'utf8')), cipher.final()])

			steedos_token = cipheredMsg.toString('base64')

			returnurl = redirectUrl + "?X-STEEDOS-WEB-ID=" + steedos_id + "&X-STEEDOS-AUTHTOKEN=" + steedos_token

			res.setHeader "Location", returnurl
			res.writeHead 302
			res.end()
			return

	res.writeHead 401
	res.end()
	return






