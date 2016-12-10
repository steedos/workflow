###
# Kick off the global namespace for Steedos.
# @namespace Steedos
###

db = {}
Steedos = 
	settings: {}
	db: db

@TabularTables = {};

if Meteor.isClient

	Steedos.isMobile = ()->
		return $(window).width() < 767

	Steedos.openWindow = (url, target)->
		target = "_blank"
		options = 'EnableViewPortScale=yes,toolbarposition=top,transitionstyle=fliphorizontal,closebuttoncaption=  x  '
		window.open(url, target, options);

	Steedos.getAccountBgBodyValue = ()->
		accountBgBody = db.steedos_keyvalues.findOne({user:Steedos.userId(),key:"bg_body"})
		if accountBgBody
			return accountBgBody.value
		else
			return {};

	Steedos.getAccountSkinValue = ()->
		accountSkin = db.steedos_keyvalues.findOne({user:Steedos.userId(),key:"skin"})
		if accountSkin
			return accountSkin.value
		else
			return {};

	Steedos.showHelp = ()->
		locale = Steedos.getLocale()
		country = locale.substring(3)
		window.open("http://www.steedos.com/" + country + "/help/", '_help', 'EnableViewPortScale=yes')

	# 左侧sidebar滚动条自适应
	Steedos.fixSideBarScroll = ()->
		if Steedos.isMobile()
			return
		if !$("#scrollspy").perfectScrollbar
			return
		if $("body").hasClass("sidebar-collapse")
			if $("#scrollspy").hasClass("ps-container")
				$("#scrollspy").perfectScrollbar("destroy")
		else if $("body").hasClass('sidebar-open')
			unless $("#scrollspy").hasClass("ps-container")
				$("#scrollspy").perfectScrollbar()
		else
			unless $("#scrollspy").hasClass("ps-container")
				$("#scrollspy").perfectScrollbar()

	#定义系统关闭函数，下次登录时自动跳转URL
	window.onunload = ()->
		# 判断用户是否登录
		if Meteor.userId()
			lastUrl = FlowRouter.current().path
			localStorage.setItem('Steedos.lastURL:' + Meteor.userId(), lastUrl)


if Meteor.isServer
	#TODO 添加服务端是否手机的判断(依据request)
	Steedos.isMobile = ()->
		return false;

	Steedos.isSpaceAdmin = (spaceId, userId)->
		if !spaceId || !userId
			return false
		space = db.spaces.findOne(spaceId)
		if !space || !space.admins
			return false;
		return space.admins.indexOf(userId)>=0

	# 判断数组orgIds中的org id集合对于用户userId是否有组织管理员权限，只要数组orgIds中任何一个组织有权限就返回true，反之返回false
	Steedos.isOrgAdminByOrgIds = (orgIds, userId)->
		isOrgAdmin = false
		useOrgs = db.organizations.find({_id: {$in:orgIds}},{fields:{parents:1,admins:1}}).fetch()
		parents = []
		allowAccessOrgs = useOrgs.filter (org) ->
			if org.parents
				parents = _.union parents,org.parents
			return org.admins?.includes(userId)
		if allowAccessOrgs.length
			isOrgAdmin = true
		else
			parents = _.flatten parents
			parents = _.uniq parents
			if parents.length and db.organizations.findOne({_id:{$in:parents}, admins:{$in:[userId]}})
				isOrgAdmin = true
		return isOrgAdmin


	# 判断数组orgIds中的org id集合对于用户userId是否有全部组织管理员权限，只有数组orgIds中每个组织都有权限才返回true，反之返回false
	Steedos.isOrgAdminByAllOrgIds = (orgIds, userId)->
		unless orgIds.length
			return true
		i = 0
		while i < orgIds.length
			isOrgAdmin = Steedos.isOrgAdminByOrgIds [orgIds[i]], userId
			unless isOrgAdmin
				break
			i++
		return isOrgAdmin


# This will add underscore.string methods to Underscore.js
# except for include, contains, reverse and join that are 
# dropped because they collide with the functions already 
# defined by Underscore.js.

mixin = (obj) ->
	_.each _.functions(obj), (name) ->
		if not _[name] and not _.prototype[name]?
			func = _[name] = obj[name]
			_.prototype[name] = ->
				args = [this._wrapped]
				push.apply(args, arguments)
				return result.call(this, func.apply(_, args))

#mixin(_s.exports())