

JsonRoutes.Middleware.use('/api/workflow/open', JsonRoutes.Middleware.authenticateMeteorUserByAccessToken);
JsonRoutes.Middleware.use('/api/workflow/open', JsonRoutes.Middleware.authenticateMeteorUserByAuthToken);

JsonRoutes.Middleware.use('/api/workflow/instances', JsonRoutes.Middleware.authenticateMeteorUserByAccessToken);
JsonRoutes.Middleware.use('/api/workflow/instances', JsonRoutes.Middleware.authenticateMeteorUserByAuthToken);
