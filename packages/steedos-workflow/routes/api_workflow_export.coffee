Meteor.startup ->
	WebApp.connectHandlers.use "/api/workflow/export", (req, res, next)->
		try
			Cookies = Npm.require("cookies")

			cookies = new Cookies(req, res)

			current_user = cookies.get("X-User-Id")

			if not current_user
				JsonRoutes.sendResult res,
					code: 500
					data: {}

			current_user_info = db.users.findOne(current_user)

			if not current_user_info
				JsonRoutes.sendResult res,
					code: 500
					data: {}

			console.log "======export======="

			ejs = Npm.require('ejs')
			str = Assets.getText('server/ejs/export_instances.ejs')
			
			console.warn str

			template = ejs.compile(str)

			ret = template({
				names: ['foo', 'bar', 'baz']
			})

			console.log(ret)


			fileName = "SteedOSWorkflow_" + moment().format('YYYYMMDDHHmm') + ".xls"
			console.log fileName
			
			res.setHeader("Content-type", "application/octet-stream")
			res.setHeader("Content-Disposition", "attachment;filename="+encodeURI(fileName))
			res.end(ret)
		catch e
			console.error e.stack
			res.end