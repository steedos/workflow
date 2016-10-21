Package.describe({
    name: 'steedos:lib',
    version: '0.0.1',
    summary: 'Steedos libraries',
    git: ''
});

Npm.depends({
    "node-schedule": "1.1.1"
});

Package.onUse(function(api) {
    api.versionsFrom('1.0');

    api.use('reactive-var');
    api.use('reactive-dict');
    api.use('coffeescript');
    api.use('random');
    api.use('ddp');
    api.use('check');
    api.use('ddp-rate-limiter');
    api.use('underscore');
    api.use('underscorestring:underscore.string');
    api.use('tracker');
    api.use('session');
    api.use('accounts-base');
    api.use('useraccounts:bootstrap');

    api.use('dburles:collection-helpers');
    api.use('flemay:less-autoprefixer@1.2.0');
    api.use('simple:json-routes');
    api.use('aldeed:simple-schema');
    api.use('aldeed:collection2');
    api.use('aldeed:tabular');
    api.use('aldeed:autoform');
    api.use('matb33:collection-hooks');
    api.use('cfs:standard-packages@0.5.9');
    api.use('iyyang:cfs-aliyun')
    api.use('cfs:s3');

    api.use('kadira:flow-router@2.10.1');
    api.use('meteorhacks:subs-manager');


    api.use(['webapp'], 'server');

    api.use('momentjs:moment', 'client');

    // TAPi18n
    api.use('templating', 'client');

    api.use('tap:i18n', ['client', 'server']);
    //api.add_files("package-tap.i18n", ["client", "server"]);
    tapi18nFiles = ['i18n/en.i18n.json', 'i18n/zh-CN.i18n.json']
    api.addFiles(tapi18nFiles, ['client', 'server']);

    // COMMON
    api.addFiles('lib/array_includes.js');
    api.addFiles('lib/core.coffee');
    api.addFiles('lib/settings.coffee', ['client', 'server']);
    api.addFiles('lib/tapi18n.coffee');

    api.addFiles('lib/models/users.coffee');
    api.addFiles('lib/models/spaces.coffee');
    api.addFiles('lib/models/space_users.coffee');
    api.addFiles('lib/models/organizations.coffee');
    api.addFiles('lib/models/users_changelogs.coffee');
    api.addFiles('lib/models/apps.coffee');
    api.addFiles('lib/models/steedos_keyvalue.coffee');
    api.addFiles('lib/models/steedos_statistics.coffee');

    api.addFiles('lib/cfs/core.coffee');
    api.addFiles('lib/cfs/avatars.coffee');

    api.addFiles('lib/methods/apps_init.coffee', 'server');
    api.addFiles('lib/methods/utc_offset.coffee');
    api.addFiles('lib/methods/last_logon.coffee');
    api.addFiles('lib/methods/user_add_email.coffee');
    api.addFiles('lib/methods/user_avatar.coffee');

    api.addFiles('lib/publications/apps.coffee');

    api.addFiles('client/momentjs/zh-cn.js', 'client');
    api.addFiles('client/helpers.coffee', 'client');
    api.addFiles('client/language.coffee', 'client');

    api.addFiles('lib/methods/emial_templates_reset.js');
    api.addFiles('lib/methods/upgrade_data.js', 'server');

    api.addFiles('server/schedule.js', 'server');


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

    api.addFiles('client/coreform/inputTypes/coreform-user/select-users.html', 'client');
    api.addFiles('client/coreform/inputTypes/coreform-user/select-users.js', 'client');

    api.addFiles('client/lib/ajax_collection.coffee', 'client');

    api.addFiles('client/lib/steedos_data_manager.js', 'client');



    api.addFiles('lib/steedos/accounts.coffee');
    api.addFiles('lib/steedos/push.coffee');

    api.addFiles('client/steedos/router.coffee', 'client');
    api.addFiles('client/steedos/tap-i18n-fix.js', 'client');
    api.addFiles('client/steedos/subscribe.coffee', 'client');

    api.addFiles('client/steedos/css/adminlte.less', 'client');
    api.addFiles('client/steedos/css/style.less', 'client');
    api.addFiles('client/steedos/css/weui.css', 'client');

    api.addFiles('client/steedos/views/animated.less', 'client');
    api.addFiles('client/steedos/views/404.less', 'client');
    api.addFiles('client/steedos/views/404.html', 'client');

    api.addFiles('client/steedos/views/admin/admin_dashboard.html', 'client');
    api.addFiles('client/steedos/views/admin/admin_dashboard.coffee', 'client');

    api.addFiles('client/steedos/views/layouts/dock.html', 'client');
    api.addFiles('client/steedos/views/layouts/dock.coffee', 'client');

    api.addFiles('client/steedos/views/layouts/main.html', 'client');

    api.addFiles('client/steedos/views/layouts/master.less', 'client');
    api.addFiles('client/steedos/views/layouts/master.html', 'client');
    api.addFiles('client/steedos/views/layouts/master.coffee', 'client');

    api.addFiles('client/steedos/views/layouts/sidebar.html', 'client');
    api.addFiles('client/steedos/views/layouts/sidebar.coffee', 'client');

    api.addFiles('client/steedos/views/layouts/sidebar_multilevel_menu.html', 'client');
    api.addFiles('client/steedos/views/layouts/sidebar_multilevel_menu.coffee', 'client');

    api.addFiles('client/steedos/views/layouts/workflow_menu.html', 'client');
    api.addFiles('client/steedos/views/layouts/workflow_menu.coffee', 'client');

    api.addFiles('client/steedos/views/login/login_layout.less', 'client');
    api.addFiles('client/steedos/views/login/login_layout.html', 'client');
    api.addFiles('client/steedos/views/login/login_layout.coffee', 'client');

    api.addFiles('client/steedos/views/profile/linked.html', 'client');
    api.addFiles('client/steedos/views/profile/linked.coffee', 'client');

    api.addFiles('client/steedos/views/profile/profile.less', 'client');
    api.addFiles('client/steedos/views/profile/profile.html', 'client');
    api.addFiles('client/steedos/views/profile/profile.coffee', 'client');

    api.addFiles('client/steedos/views/space/space_info.html', 'client');
    api.addFiles('client/steedos/views/space/space_info.coffee', 'client');

    api.addFiles('client/steedos/views/space/space_select.html', 'client');
    api.addFiles('client/steedos/views/space/space_select.coffee', 'client');

    api.addFiles('client/steedos/views/space/space_switcher.less', 'client');
    api.addFiles('client/steedos/views/space/space_switcher.html', 'client');
    api.addFiles('client/steedos/views/space/space_switcher.coffee', 'client');

    api.addFiles('client/steedos/views/springboard/springboard.less', 'client');
    api.addFiles('client/steedos/views/springboard/springboard.html', 'client');
    api.addFiles('client/steedos/views/springboard/springboard.coffee', 'client');


    api.addFiles('server/steedos/startup/migrations/v1.coffee', 'server');
    api.addFiles('server/steedos/startup/migrations/v2.coffee', 'server');
    api.addFiles('server/steedos/startup/migrations/xrun.coffee', 'server');

    // methods
    api.addFiles('server/methods/setKeyValue.js', 'server');


    api.addFiles('client/steedos/views/sidebar/top_sidebar.html', 'client');
    api.addFiles('client/steedos/views/sidebar/top_sidebar.coffee', 'client');
    api.addFiles('client/steedos/views/sidebar/top_sidebar.less', 'client');

    api.addFiles('client/steedos/views/sidebar/app_list_box_modal.html', 'client');
    api.addFiles('client/steedos/views/sidebar/app_list_box_modal.coffee', 'client');
    api.addFiles('client/steedos/views/sidebar/app_list_box_modal.less', 'client');



    // EXPORT
    api.export('Steedos');
    api.export('db');
    api.export('SteedosOffice');
    api.export("CFDataManager");

    api.export('AjaxCollection');
    api.export("SteedosDataManager");
});

Package.onTest(function(api) {

});