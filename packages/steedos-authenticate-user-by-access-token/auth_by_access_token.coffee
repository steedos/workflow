Fiber = Npm.require('fibers');

JsonRoutes.Middleware.authenticateMeteorUserByAccessToken = (req, res, next)->

	Fiber(()->
		userId = Steedos.getUserIdFromAuthToken(req.query?.access_token);

		if userId
			req.userId = userId;

		next();
	).run()