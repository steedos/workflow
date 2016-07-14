TemplateHelpers = 

	equals: (a, b)->
		return a == b
		
	session: (v)->
		return Session.get(v)
		
	absoluteUrl: ->
		return Meteor.absoluteUrl()

	urlPrefix: ->
		return __meteor_runtime_config__.ROOT_URL_PATH_PREFIX

	isMobile: ->
		return $(window).width()<767

	userId: ->
		return Meteor.userId()

	setSpaceId: (spaceId)->
		if !spaceId
			Session.set("spaceId", null)    
			localStorage.removeItem("spaceId:" + Meteor.userId())
		else if spaceId != Session.get("spaceId")
			Session.set("spaceId", spaceId)     
			localStorage.setItem("spaceId:" + Meteor.userId(), spaceId);

	getSpaceId: ()->

		spaceId = Session.get("spaceId")
		if spaceId
			return spaceId

		spaceId = localStorage.getItem("spaceId:" + Meteor.userId())
		if spaceId
			return spaceId
		else
			return undefined;
			
	isSpaceAdmin: (spaceId)->
		if !spaceId
			spaceId = Steedos.getSpaceId()
		if spaceId
			s = db.spaces.findOne(spaceId)
			if s
				return s.admins.includes(Meteor.userId())

	isSpaceOwner: (spaceId)->
		if !spaceId
			spaceId = Steedos.getSpaceId()
		if spaceId
			s = db.spaces.findOne(spaceId)
			if s
				return s.owner == Meteor.userId()

	spaceId: ()->
		return Steedos.getSpaceId();

	spaceName: (spaceId)->
		if !spaceId
			spaceId = Steedos.getSpaceId()
		if spaceId
			space = db.spaces.findOne(spaceId)
			if space
				return space.name

	isCloudAdmin: ->
		return Meteor.user()?.is_cloudadmin

	setAppId: (appId)->
		if appId != Session.get("appId")
			Session.set("appId", appId)     
			localStorage.setItem("appId:" + Meteor.userId(), appId);

	getAppId: ()->

		appId = Session.get("appId")
		if appId
			return appId

		appId = localStorage.getItem("appId:" + Meteor.userId())
		if appId
			return appId
		else
			return undefined;

	getSpaceApps: ()->
		selector = {}
		if Steedos.getSpaceId()
			space = db.spaces.findOne(Steedos.getSpaceId())
			if space?.apps_enabled?.length>0
				selector._id = {$in: space.apps_enabled}
		if Steedos.isMobile()
			selector.mobile = true
		return db.apps.find(selector, {sort: {sort: 1, space_sort: 1}});

	getLocale: ()->
		if Meteor.user()?.locale
			locale = Meteor.user().locale
		else
			l = window.navigator.userLanguage || window.navigator.language || 'en'
			if l.indexOf("zh") >=0
				locale = "zh-cn"
			else
				locale = "en-us"

	getBadge: (appId, spaceId)->
		if !appId
			return;
		badge = 0
		if appId == "chat"
			subscriptions = db.rocketchat_subscription.find().fetch()
			_.each subscriptions, (s)->
				badge = badge + s.unread
		else 
			if spaceId
				b = db.steedos_keyvalues.findOne({user: Meteor.userId(), space: spaceId, key: "badge"})
				if b
					badge = b.value?[appId]
			else
				b = db.steedos_keyvalues.findOne({user: Meteor.userId(), space: null, key: "badge"})
				if b
					badge = b.value?[appId]
		if badge 
			return badge


	locale: ->
		return Steedos.getLocale()

	country: ->
		locale = Steedos.getLocale()
		if locale == "zh-cn"
			return "cn"
		else
			return "us"

	fromNow: (posted)->
		return moment(posted).fromNow()



	isPaid: (app)->
		if !app
			app = "workflow"
		if Session.get('spaceId')
			space = db.spaces.findOne(Session.get('spaceId'))
			if space?.apps_paid?.length >0
				return _.indexOf(space.apps_paid, app)>=0 


_.extend Steedos, TemplateHelpers

Template.registerHelpers TemplateHelpers

