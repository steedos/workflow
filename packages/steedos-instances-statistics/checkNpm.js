import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'request': '^2.81.0',
	'node-schedule': '^1.3.1'
}, 'steedos:instances-statistics');