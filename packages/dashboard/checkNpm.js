import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'request': '2.81.x',
	'node-schedule': '1.3.x',
	cookies: "0.6.x",
}, 'steedos:dashboard');