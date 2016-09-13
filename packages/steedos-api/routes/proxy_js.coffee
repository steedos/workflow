Meteor.startup ->
    
    ProxyJS =
        max_request_length: 100000
        fetch_regex: /^\/fetch\/(.*)$/
        publicIP: ""
        proxy_request_timeout_ms: 10000
        enable_logging: true
        enable_rate_limiting: false

        addCORSHeaders: (req, res)->
            if req.method.toUpperCase() == 'OPTIONS'
                if req.headers['access-control-request-headers']
                    res.setHeader 'Access-Control-Allow-Headers', req.headers['access-control-request-headers']
                if req.headers['access-control-request-method']
                    res.setHeader 'Access-Control-Allow-Methods', req.headers['access-control-request-method']

            if req.headers['origin']
                res.setHeader 'Access-Control-Allow-Origin', req.headers['origin']
            else
                res.setHeader 'Access-Control-Allow-Origin', '*'
        
        writeResponse: (res, httpCode, body)->
            res.statusCode = httpCode;
            res.end(body);
            
        sendInvalidURLResponse: (res)->
            return @writeResponse(res, 404, "url must be in the form of /fetch/{some_url_here}");
            
        sendTooBigResponse: (res)->
            return @writeResponse(res, 413, "the content in the request or response cannot exceed " + @max_request_length + " characters.");
            
        getClientAddress: (req)->
            return (req.headers['x-forwarded-for'] or '').split(',')[0] or req.connection.remoteAddress

        processRequest: (req, res)->
            @addCORSHeaders req, res
            # Return options pre-flight requests right away
            if req.method.toUpperCase() == 'OPTIONS'
                return @writeResponse(res, 204)
            result = @fetch_regex.exec(req.url)
            if result and result.length == 2 and result[1]
                remoteURL = undefined
                try
                    remoteURL = url.parse(decodeURI(result[1]))
                catch e
                    return @sendInvalidURLResponse(res)
                # We don't support relative links
                if !remoteURL.host
                    return @writeResponse(res, 404, 'relative URLS are not supported')
                # Naughty, naughty— deny requests to blacklisted hosts
                if config.blacklist_hostname_regex.test(remoteURL.hostname)
                    return @writeResponse(res, 400, 'naughty, naughty...')
                # We only support http and https
                if remoteURL.protocol != 'http:' and remoteURL.protocol != 'https:'
                    return @writeResponse(res, 400, 'only http and https are supported')
                if @publicIP
                    # Add an X-Forwarded-For header
                    if req.headers['x-forwarded-for']
                        req.headers['x-forwarded-for'] += ', ' + @publicIP
                    else
                        req.headers['x-forwarded-for'] = req.clientIP + ', ' + @publicIP
                # Make sure the host header is to the URL we're requesting, not thingproxy
                if req.headers['host']
                    req.headers['host'] = remoteURL.host
                proxyRequest = request(
                    url: remoteURL
                    headers: req.headers
                    method: req.method
                    timeout: @proxy_request_timeout_ms
                    strictSSL: false)
                proxyRequest.on 'error', (err) ->
                    if err.code == 'ENOTFOUND'
                        @writeResponse res, 502, 'host cannot be found.'
                    else
                        console.log 'Proxy Request Error: ' + err.toString()
                        @writeResponse res, 500
                requestSize = 0
                proxyResponseSize = 0
                req.pipe(proxyRequest).on 'data', (data) ->
                    requestSize += data.length
                    if requestSize >= config.max_request_length
                        proxyRequest.end()
                        return sendTooBigResponse(res)
                    return
                proxyRequest.pipe(res).on 'data', (data) ->
                    proxyResponseSize += data.length
                    if proxyResponseSize >= config.max_request_length
                        proxyRequest.end()
                        return sendTooBigResponse(res)
                    return

                res.end()
            else
                return @sendInvalidURLResponse(res)
            return



    JsonRoutes.add 'get', '/proxy_js/:url', (req, res, next) ->
        console.log 123
        # Process AWS health checks
        if req.url == '/health'
            return ProxyJS.writeResponse(res, 200)
        clientIP = ProxyJS.getClientAddress(req)
        req.clientIP = clientIP
        # Log our request
        if ProxyJS.enable_logging
            console.log '%s %s %s', (new Date).toJSON(), clientIP, req.method, req.url
        if ProxyJS.enable_rate_limiting
            # throttle.rateLimit clientIP, (err, limited) ->
            #     if limited
            #         return ProxyJS.writeResponse(res, 429, 'enhance your calm')
            #     ProxyJS.processRequest req, res
            #     return
        else
            ProxyJS.processRequest req, res
        return