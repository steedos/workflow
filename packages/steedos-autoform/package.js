/**
 * Created by dell on 2017/6/12.
 */
Package.describe({
	name: 'steedos:autoform',
	version: '0.0.1',
	summary: 'Steedos libraries',
	git: 'https://github.com/steedos/platform/packages/steedos-theme'
});

Package.onUse(function(api) {
	api.versionsFrom('METEOR@1.3');

	api.use('session');
	api.use('coffeescript');
	api.use('ecmascript');
	api.use('blaze-html-templates');
	api.use('underscore');
	api.use('reactive-var');
	api.use('tracker');

	api.use('accounts-base');
	api.use('steedos:useraccounts-bootstrap@1.14.2');
	api.use('steedos:useraccounts-core@1.14.2');
	// api.use('useraccounts:flow-routing@1.14.2');
	api.use('softwarerero:accounts-t9n@1.3.3');

	api.use('matb33:collection-hooks@0.8.4');
	api.use('flemay:less-autoprefixer@1.2.0');
	api.use('kadira:flow-router@2.10.1');
	api.use('meteorhacks:subs-manager@1.6.4');

	api.use('momentjs:moment@2.14.1');

	api.use('tap:i18n@1.8.2');
	api.use('aldeed:simple-schema@1.5.3');
	api.use('aldeed:tabular@1.6.1');
	api.use('aldeed:autoform@5.8.0');
	api.use('momentjs:moment');

	api.use('steedos:i18n@0.0.2');
	api.use('steedos:jstree')
	api.use('steedos:base');

	api.addFiles('client/core.coffee');

	api.addFiles('client/coreform/inputTypes/coreform-org-localdata/select-orgs.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-org-localdata/select-orgs.js', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-org/lib/cf_organization.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-org/lib/cf_organization.coffee', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-org/lib/cf_organization_modal.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-org/lib/cf_organization_modal.coffee', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-org/lib/cf_organization_modal.less', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-org/select-orgs.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-org/select-orgs.js', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-user-localdata/select-users.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user-localdata/select-users.js', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_data_manager.js', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_tabular_space_user.coffee');

	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_contact_modal.less', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_contact_modal.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_contact_modal.coffee', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_organization_list.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_organization_list.coffee', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_space_user_list.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_space_user_list.coffee', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_organization_modal.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/lib/cf_organization_modal.coffee', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-user/select-users.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-user/select-users.js', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-email/email.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-email/email.js', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-url/url.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-url/url.js', 'client');

	api.addFiles('client/coreform/inputTypes/coreform-typeahead/typeahead.js/bloodhound.js', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-typeahead/typeahead.js/typeahead.bundle.js', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-typeahead/typeahead.js/typeahead.jquery.js', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-typeahead/af-typeahead.less', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-typeahead/af-typeahead.html', 'client');
	api.addFiles('client/coreform/inputTypes/coreform-typeahead/af-typeahead.coffee', 'client');
});

Package.onTest(function(api) {

});

