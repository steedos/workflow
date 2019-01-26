import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	"debug": "0.7.x",
	"kadira-core": "1.3.x",
	"pidusage": "1.0.x",
	"evloop-monitor": "0.1.x",
	"pidusage": "0.1.x",
	"lru-cache": "4.0.x",
	"json-stringify-safe": "5.0.x"
}, 'meteorhacks:kadira');