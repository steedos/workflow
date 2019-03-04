// fix warning: xxx not installed
require("chalk/package.json");

import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'chalk': '^1.1.3'
}, 'steedos:logger');