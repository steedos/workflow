import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'cookies': "^0.6.2",
	'xml2js': "^0.4.19"
}, 'steedos:cas');