import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'request': '2.40.0',
	'node-schedule': '1.2.1',
	cookies: "0.6.1"
}, 'Steedos libraries');