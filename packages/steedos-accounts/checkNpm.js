import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	cookies: "0.6.x",
	phone: "1.0.x",
	sha256: "0.2.x",
	"urijs": "1.19.x"
}, 'steedos:accounts');