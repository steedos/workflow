import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'node-schedule': '1.3.x'
}, 'steedos:remind');