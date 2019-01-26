import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	'aliyun-sdk': '1.9.x',
	busboy: "0.2.x",
	cookies: "0.6.x",
	mime: "2.0.x",
	'csv': "1.1.x",
	'url': '0.11.x',
	'request': '2.81.x',
	'xinge': '1.1.x',
	'huawei-push': '0.0.6-0',
	'xiaomi-push': '0.4.5'
}, 'steedos:api');