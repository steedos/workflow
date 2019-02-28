import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'request': '^2.81.0',
	'mkdirp': "^0.3.5"
}, 'steedos:records');