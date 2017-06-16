Package.describe({
	name: 'steedos:datatables-extensions',
	summary: 'datatables extensions for MeteorJS.',
	version: '0.0.1',
	git: 'https://github.com/steedos/apps/tree/master/packages/steedos-datatables-extensions',
	documentation: null
});

Package.onUse(function(api) {
	api.addFiles([
		'extensions/dataTables.conditionalPaging.js',
		'extensions/dataTables.responsive.js',
		'extensions/dataTables.select.js',
		'extensions/responsive.bootstrap.js',
		'extensions/responsive.bootstrap.css',
		'extensions/select.bootstrap.css'
	], 'client');
});
