# Adding CORS headers so we can use CDNs for static content

# Try to parse all request bodies as JSON
WebApp.rawConnectHandlers.use (req, res, next) ->
	if req._body
		return next()

	if req.headers['transfer-encoding'] is undefined and isNaN(req.headers['content-length'])
		return next()

	if req.headers['content-type'] not in ['', undefined]
		return next()

	buf = ''
	req.setEncoding('utf8')
	req.on 'data', (chunk) -> buf += chunk
	req.on 'end', ->
		if Steedos?.debugLevel? and Steedos.debugLevel is 'debug'
			console.log '[request]'.green, req.method, req.url, '\nheaders ->', req.headers, '\nbody ->', buf

		try
			req.body = JSON.parse(buf)
		catch err
			req.body = buf

		req._body = true
		next()


WebApp.rawConnectHandlers.use (req, res, next) ->
	#if /^\/(api|_timesync|sockjs|tap-i18n)(\/|$)/.test req.url
	method = req.method && req.method.toUpperCase && req.method.toUpperCase();

	if req.headers.origin
		res.setHeader("Access-Control-Allow-Credentials", "true");
		res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, DELETE");
		res.setHeader("Access-Control-Allow-Origin", req.headers.origin)
	else
		res.setHeader("Access-Control-Allow-Origin", "*")

	if method == 'OPTIONS'
		res.setHeader("Access-Control-Allow-Headers", "Origin,X-Requested-With,Content-Type,Accept,X-Auth-Token,X-User-Id");
		res.statusCode = 204;
		res.setHeader('Content-Length', '0');
		res.end();
		return ;

	# Block next handlers to override CORS with value http://meteor.local
	setHeader = res.setHeader
	res.setHeader = (key, val) ->
		if key.toLowerCase() is 'access-control-allow-origin' and val is 'http://meteor.local'
			return
		return setHeader.apply @, arguments

	return next()

_staticFilesMiddleware = WebAppInternals.staticFilesMiddleware
WebAppInternals._staticFilesMiddleware = (staticFiles, req, res, next) ->
	res.setHeader("Access-Control-Allow-Origin", "*")
	_staticFilesMiddleware(staticFiles, req, res, next)


