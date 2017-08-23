Package.describe({
	name: 'steedos:tableau',
	version: '0.0.10',
	summary: 'Steedos tableau',
	git: ''
});

Npm.depends({
	cookies: "0.6.1",
});

Package.onUse(function (api) {
	api.versionsFrom('1.0');

	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('coffeescript');
	api.use('random');
	api.use('ddp');
	api.use('check');
	api.use('ddp-rate-limiter');
	api.use('underscore');
	api.use('tracker');
	api.use('session');
	api.use('blaze');
	api.use('templating');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('simple:json-routes@2.1.0');
	api.use('nimble:restivus@0.8.7');
	api.use('aldeed:simple-schema@1.3.3');
	api.use('aldeed:collection2@2.5.0');
	api.use('aldeed:tabular@1.6.1');
	api.use('aldeed:autoform@5.8.0');
	api.use('matb33:collection-hooks@0.8.1');
	api.use('cfs:standard-packages@0.5.9');
	api.use('kadira:blaze-layout@2.3.0');
	api.use('kadira:flow-router@2.10.1');
	api.use('iyyang:cfs-aliyun')
	api.use('cfs:s3');

	api.use('meteorhacks:ssr@2.2.0');
	api.use('tap:i18n@1.7.0');
	api.use('meteorhacks:subs-manager');

	api.use(['webapp'], 'server');

	api.use('momentjs:moment', 'client');
	api.use('mrt:moment-timezone', 'client');
	api.use('steedos:base');
	api.use('steedos:admin');
	api.use('steedos:workflow');

	api.use('tap:i18n', ['client', 'server']);

	tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
	api.addFiles(tapi18nFiles, ['client', 'server']);

	api.addFiles('server/routes/search_organizations.coffee', 'server');

	api.addAssets("assets/steedos_tableau.js", "client");
	api.addAssets("assets/steedos_tableau.css", "client");

	api.addAssets("assets/instances/instance_by_flow_tableau_connectors.html", "server");
	api.addAssets("assets/instances/instance_by_flow_tableau_connectors.js", "client");
	api.addFiles('server/routes/instance_by_flow_tableau_api.coffee', 'server');

	api.addAssets("assets/instances/instance_avg_cost_time_connectors.html", "server");
	api.addAssets("assets/instances/instance_avg_cost_time_connectors.js", "client");
	api.addFiles('server/routes/instance_avg_cost_time_connectors_api.coffee', 'server');

	api.addFiles('server/data/api_workflow_instances_approve_cost_time.coffee', 'server');
	api.addFiles('server/data/api_space_organizations.coffee', 'server');

	api.addFiles('client/steedos_tableau.less', 'client');
	api.addFiles('client/tableau_info.html', 'client');
	api.addFiles('client/tableau_info.coffee', 'client');
	api.addFiles('client/workflow/tableau_flow_list.html', 'client');
	api.addFiles('client/workflow/tableau_flow_list.coffee', 'client');

	api.addFiles('client/lib/steedos_tableau.coffee', 'client');

	api.addFiles('tabulars/flows.coffee');

	api.addFiles('client/admin-menu.coffee', 'client');

	api.addFiles('client/router.coffee', 'client');

	api.export("SteedosTableau", 'client');
});

Package.onTest(function (api) {

});