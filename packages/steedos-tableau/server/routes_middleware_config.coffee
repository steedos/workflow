
JsonRoutes.Middleware.use('/tableau/api', JsonRoutes.Middleware.authenticateMeteorUserByAccessToken);
JsonRoutes.Middleware.use('/tableau/search', JsonRoutes.Middleware.authenticateMeteorUserByAccessToken);