import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'cookies': "0.6.x",
	'xml2js': "0.4.x"
}, 'steedos:cas');