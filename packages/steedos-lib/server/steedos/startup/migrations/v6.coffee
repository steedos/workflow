Meteor.startup ->
	Migrations.add
		version: 6
		name: '财务系统升级'
		up: ->
			console.log 'version 6 up'
			console.time 'billing upgrade'
			try
				start_date = new Date
				start_date.setHours(0)
				start_date.setMinutes(0)
				start_date.setSeconds(0)
				start_date.setMilliseconds(0)
				db.spaces.find({is_paid: true, user_limit: {$exists: false}}).forEach (s)->
					set_obj = {}
					user_count = db.space_users.find({space: s._id, user_accepted: true}).count()
					set_obj.user_limit = user_count
					balance = s.balance
					if balance > 0
						months = 0
						listprices = 0
						_.each s.modules, (pm)->
							module = db.modules.findOne({name: pm})
							if module and module.listprice
								listprices += module.listprice
						months = parseInt((balance/listprices).toFixed()) + 1
						end_date = new Date
						end_date.setMonth(end_date.getMonth()+months)
						end_date.setHours(0)
						end_date.setMinutes(0)
						end_date.setSeconds(0)
						end_date.setMilliseconds(0)
						set_obj.start_date = start_date
						set_obj.end_date = end_date

					else if balance <= 0
						set_obj.start_date = start_date
						set_obj.end_date = new Date

					db.spaces.direct.update({_id: s._id}, {$set: set_obj})

			catch e
				console.error "billing upgrade"
				console.error e.stack

			console.timeEnd 'billing upgrade'
		down: ->
			console.log 'version 6 down'
