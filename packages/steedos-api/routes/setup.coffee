Cookies = Npm.require("cookies")
bcrypt = NpmModuleBcrypt;
bcryptHash = Meteor.wrapAsync(bcrypt.hash);
bcryptCompare = Meteor.wrapAsync(bcrypt.compare);

Setup.clearAuthCookies = (req, res) ->
		cookies = new Cookies( req, res );
		cookies.set("X-User-Id")
		cookies.set("X-Auth-Token")

Setup.setAuthCookies = (req, res, userId, authToken) ->
		cookies = new Cookies( req, res );
		# set cookie to response
		# maxAge 3 month
		cookies.set "X-User-Id", userId, 
			domain: Steedos.uri.domain(),
			maxAge: 90*60*60*24*1000,
			httpOnly: false
			overwrite: true
		cookies.set "X-Auth-Token", authToken, 
			domain: Steedos.uri.domain(),
			maxAge: 90*60*60*24*1000,
			httpOnly: false
			overwrite: true



JsonRoutes.add "post", "/api/setup/validate", (req, res, next) ->
	cookies = new Cookies( req, res );

	# first check request body
	if req.body
		userId = req.body["X-User-Id"]
		authToken = req.body["X-Auth-Token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if userId and authToken
		hashedToken = Accounts._hashLoginToken(authToken)
		user = Meteor.users.findOne
			_id: userId,
			"services.resume.loginTokens.hashedToken": hashedToken
		if user
			Setup.setAuthCookies(req, res, userId, authToken)

			JsonRoutes.sendResult res, 
				data: 
					userId: user._id
					authToken: authToken
					apps: []
					dsInfo: 
						dsid: user._id
						steedosId: user.steedos_id
						name: user.name
						primaryEmail: user.email
						statusCode: 2
					instance: "1329598861"
					isExtendedLogin: true
					requestInfo:
						country: "CN"
						region: "SH"
						timezone: "GMT+8"
					webservices:
						Steedos.settings.webservices
			return


	JsonRoutes.sendResult res, 
		code: 401,
		data: 
			"error": "Validate Request -- Missing X-Auth-Token", 
			"instance": "1329598861", 
			"success": false


JsonRoutes.add "post", "/api/setup/logout", (req, res, next) ->

	Setup.clearAuthCookies(req, res)

	res.end();


JsonRoutes.add "post", "/api/setup/login", (req, res, next) ->

	cookies = new Cookies( req, res );

	username = req.body["username"]
	password = req.body["password"]
	extended_login = req.body["extended_login"]

	bcryptPassword = SHA256(password);

	user = Meteor.users.findOne
		"emails.address": username

	if !user
		res.statusCode = 401;
		res.end();
		return

	if (!bcryptCompare(bcryptPassword, user.services.password.bcrypt)) 
		res.statusCode = 401;
		res.end();
		return


	authToken = Accounts._generateStampedLoginToken()
	hashedToken = Accounts._hashStampedToken authToken
	Accounts._insertHashedLoginToken user._id, hashedToken

	# set cookie to response
	# maxAge 3 month
	Setup.setAuthCookies(req, res, user._id, authToken.token)

	JsonRoutes.sendResult res, 
		data: 
			userId: user._id
			authToken: authToken.token
			apps: []
			dsInfo: 
				dsid: user._id
				steedosId: user.steedos_id
				name: user.name
				primaryEmail: user.email
				statusCode: 2
			instance: "1329598861"
			isExtendedLogin: true
			requestInfo:
				country: "CN"
				region: "SH"
				timezone: "GMT+8"
			webservices:
				Steedos.settings.webservices



JsonRoutes.add "get", "/api/login/validate", (req, res, next) ->
	email = req.query.email
	password = req.query.password
	console.log req.query

	if !email || !password
		res.statusCode = 401;
		res.end();
		return

	bcryptPassword = SHA256(password);

	user = Meteor.users.findOne
		"emails.address": email

	if !user
		res.statusCode = 401;
		res.end();
		return

	if (!bcryptCompare(bcryptPassword, user.services.password.bcrypt)) 
		res.statusCode = 401;
		res.end();
		return

	JsonRoutes.sendResult res, 
		code: 200,
		data: 
			"success": true

