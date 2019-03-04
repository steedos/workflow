import { checkNpmVersions } from 'meteor/tmeasday:check-npm-versions';
checkNpmVersions({
	"debug": "^0.7.4",
	"kadira-core": "^1.3.2",
	"pidusage": "^1.0.1",
	"evloop-monitor": "^0.1.0",
	"lru-cache": "^4.0.0",
	"json-stringify-safe": "^5.0.1"
}, 'meteorhacks:kadira');