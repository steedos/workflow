import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'aliyun-sdk': '1.9.2',
	busboy: "0.2.13",
	cookies: "0.6.2",
	mime: "2.0.2",
	'csv': "1.1.0",
	'url': '0.11.0',
	'request': '2.65.x',
	'xinge': '1.1.3',
	'huawei-push': '0.0.6-0',
	'xiaomi-push': '0.4.5'
}, 'steedos:api');