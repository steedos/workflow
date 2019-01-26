import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	"aliyun-sms-node": "1.1.x"
}, 'steedos:smsqueue');