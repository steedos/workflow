Package.describe({
	name: 'steedos:email',
	version: '0.0.1',
	summary: 'Steedos Email',
	git: ''
});

Npm.depends({
	busboy: "0.2.13",
	cookies: "0.6.1",
	mime: "1.3.4",
	"node-forge": "0.6.41",
	"emailjs-imap-client": "2.0.2",
	"emailjs-smtp-client": "1.0.0",
	"emailjs-addressparser": "1.0.1",
	"emailjs-imap-handler": "1.0.0",
	"emailjs-mime-codec": "1.0.1",
	"emailjs-tcp-socket": "1.0.1",
	"emailjs-utf7": "3.0.1",
	"emailjs-stringencoding": "1.0.1",
	"emailjs-mime-builder": "1.0.1",
	"emailjs-mime-parser":"1.0.0"
});


Package.onUse(function(api) { 
    api.versionsFrom("1.2.1");

	api.use('reactive-var');
	api.use('reactive-dict');
	api.use('coffeescript');
	api.use('random');
	api.use('check');
    api.use('ddp');
    api.use('ddp-common');
	api.use('ddp-rate-limiter');
	api.use('underscore');
	api.use('tracker');
	api.use('session');
	api.use('accounts-base');
	api.use('sha');
	api.use('npm-bcrypt');
	api.use('webapp', 'server');
	api.use('accounts-password@1.1.4');

	api.use('cfs:standard-packages');
	api.use('raix:push');
	api.use('simple:json-routes@2.1.0');

	api.use('steedos:lib');
});

Package.onTest(function(api) {

});
