import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'request': '^2.81.0',
	'node-schedule': '^1.3.1',
	"eval": "^0.1.2",
	cookies: "^0.6.2",
	mkdirp: "^0.3.5"
}, 'steedos:qhd-archives');