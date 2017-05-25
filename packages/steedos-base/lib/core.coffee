db = {}

Steedos = 
	settings: {}
	db: db
	subs: {}
	isPhoneEnabled: ->
		return !!Meteor.settings?.public?.phone

if Meteor.isServer
	_.extend Steedos,
		getSteedosToken: (appId, userId, authToken)->
			crypto = Npm.require('crypto')
			app = db.apps.findOne(appId)
			if app
				secret = app.secret
				
			if userId and authToken
				hashedToken = Accounts._hashLoginToken(authToken)
				user = Meteor.users.findOne
					_id: userId,
					"services.resume.loginTokens.hashedToken": hashedToken
				if user
					steedos_id = user.steedos_id
					if app.secret
						iv = app.secret
					else
						iv = "-8762-fcb369b2e8"
					now = parseInt(new Date().getTime()/1000).toString()
					key32 = ""
					len = steedos_id.length
					if len < 32
						c = ""
						i = 0
						m = 32 - len
						while i < m
							c = " " + c
							i++
						key32 = steedos_id + c
					else if len >= 32
						key32 = steedos_id.slice(0,32)

					cipher = crypto.createCipheriv('aes-256-cbc', new Buffer(key32, 'utf8'), new Buffer(iv, 'utf8'))

					cipheredMsg = Buffer.concat([cipher.update(new Buffer(now, 'utf8')), cipher.final()])

					steedos_token = cipheredMsg.toString('base64')
				
			return steedos_token