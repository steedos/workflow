Package.describe({
        name: 'steedos:ui',
        version: '0.0.1',
        summary: 'Steedos ui',
        git: ''
});

Package.onUse(function(api) { 
        api.versionsFrom('1.0');

        api.use(['flemay:less-autoprefixer']);

        api.use([
                'mongo',
                'session',
                'jquery',
                'tracker',
                'reactive-var',
                'ecmascript',
                'templating',
                'coffeescript',
                'underscore',
                'steedos:lib',
        ]);

        api.addFiles('lib/Modernizr.js', 'client');

        api.addFiles('lib/steedos.coffee', 'client');
        api.addFiles('lib/fireGlobalEvent.coffee', 'client');
        api.addFiles('lib/helpers.coffee', 'client');
        api.addFiles('lib/navigation_controller.coffee', 'client');

        api.addFiles('utils/_lesshat.import.less', 'client');
        api.addFiles('utils/_keyframes.import.less', 'client');
});

Package.onTest(function(api) {

});
