import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	"wechat-crypto": "0.0.2",
	"request": "2.65.0",
	'node-schedule': '1.3.x'
}, 'steedos:connect-dingtalk');