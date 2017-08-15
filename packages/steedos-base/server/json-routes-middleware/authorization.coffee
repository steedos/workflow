#JsonRoutes.Middleware.use (req, res, next)->
#	console.log("JsonRoutes.Middleware.use next", next);
#	next();



###

###
JsonRoutes.Middleware.parseBearerAccountsToken = (req, res, next)->

	userId = req.query?.userId
	authToken = req.query?.authToken
	if Steedos.checkAuthToken(userId,authToken)
		req.user = db.users.findOne({_id: userId})


	cookies = new Cookies(req, res);

	if req.headers
		userId = req.headers["x-user-id"]
		authToken = req.headers["x-auth-token"]

	# then check cookie
	if !userId or !authToken
		userId = cookies.get("X-User-Id")
		authToken = cookies.get("X-Auth-Token")

	if !userId or !authToken
		return false

	if Steedos.checkAuthToken(userId, authToken)
		req.user = db.users.findOne({_id: userId})