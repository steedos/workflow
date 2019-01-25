import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	"node-schedule": "1.3.x",
	cookies: "0.6.x",
	"weixin-pay": "1.1.x",
	"xml2js": "0.4.x",
	mkdirp: "0.3.x",
	"sprintf-js": "1.1.2",
}, 'steedos:workflow');

// checkNpmVersions({
// 	cookies: "0.6.1",
// 	ejs: "2.5.5",
// 	"ejs-lint": "0.2.0",
// 	"eval": "0.1.2",
// 	mkdirp: "0.3.5",
// 	mime: "2.0.2",
// 	busboy: "0.2.13",
// 	"node-schedule": "1.2.1"
// }, 'steedos:workflow');