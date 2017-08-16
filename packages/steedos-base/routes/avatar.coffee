Meteor.startup ->
	
	JsonRoutes.add 'get', '/avatar/:userId', (req, res, next) ->
		# this.params =
		# 	userId: decodeURI(req.url).replace(/^\//, '').replace(/\?.*$/, '')
		width = 50 ;
		height = 50 ;
		fontSize = 28 ;
		if req.query.w
		    width = req.query.w ;
		if req.query.h
		    height = req.query.h ;
		if req.query.fs
            fontSize = req.query.fs ;

		user = db.users.findOne(req.params.userId);
		if !user
			res.writeHead 401
			res.end()
			return

		if user.avatar
			res.setHeader "Location", Steedos.absoluteUrl("api/files/avatars/" + user.avatar)
			res.writeHead 302
			res.end()
			return

		if user.avatarUrl
			res.setHeader "Location", user.avatarUrl
			res.writeHead 302
			res.end()
			return

		if not file?
			res.setHeader "Location", Steedos.absoluteUrl("/packages/steedos_base/client/images/default-avatar.png")
			res.writeHead 302
			res.end()
			return

		username = user.name;
		if !username
			username = ""

		res.setHeader 'Content-Disposition', 'inline'

		if not file?
			res.setHeader 'content-type', 'image/svg+xml'
			res.setHeader 'cache-control', 'public, max-age=31536000'

			colors = ['#F44336','#E91E63','#9C27B0','#673AB7','#3F51B5','#2196F3','#03A9F4','#00BCD4','#009688','#4CAF50','#8BC34A','#CDDC39','#FFC107','#FF9800','#FF5722','#795548','#9E9E9E','#607D8B']

			username_array = Array.from(username)
			color_index = 0
			_.each username_array, (item) ->
				color_index += item.charCodeAt(0);

			position = color_index % colors.length
			color = colors[position]
			#color = "#D6DADC"

			initials = ''
			if username.charCodeAt(0)>255
				initials = username.substr(0, 1)
			else
				initials = username.substr(0, 2)

			initials = initials.toUpperCase()

			svg = """
			<?xml version="1.0" encoding="UTF-8" standalone="no"?>
			<svg xmlns="http://www.w3.org/2000/svg" pointer-events="none" width="#{width}" height="#{height}" style="width: #{width}px; height: #{height}px; background-color: #{color};">
				<text text-anchor="middle" y="50%" x="50%" dy="0.36em" pointer-events="auto" fill="#FFFFFF" font-family="-apple-system, BlinkMacSystemFont, Helvetica, Arial, Microsoft Yahei, SimHei" style="font-weight: 400; font-size: #{fontSize}px;">
					#{initials}
				</text>
			</svg>
			"""

			res.write svg
			res.end()
			return

		reqModifiedHeader = req.headers["if-modified-since"];
		if reqModifiedHeader?
			if reqModifiedHeader == user.modified?.toUTCString()
				res.setHeader 'Last-Modified', reqModifiedHeader
				res.writeHead 304
				res.end()
				return

		res.setHeader 'Last-Modified', user.modified?.toUTCString() or new Date().toUTCString()
		res.setHeader 'content-type', 'image/jpeg'
		res.setHeader 'Content-Length', file.length

		file.readStream.pipe res
		return