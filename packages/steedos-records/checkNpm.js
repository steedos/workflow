import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'request': '2.81.x',
	'mkdirp': "0.3.x"
}, 'steedos:records');