import {moment} from 'meteor/momentjs:moment';

Steedos.Helpers = 

	isMobile: ()->
		return $(window).width() < 767

	isPad: ()->
		return /iP(ad)/.test(navigator.userAgent)

	getAppTitle: ()->
		t = Session.get("app_title")
		if t
			return t
		else
			return "Steedos"

	# 根据当前路由路径前缀，得到当前所属app名字
	getAppName: (path)->
		unless path
			path = FlowRouter.current().path
		if /^\/?workflow\b/.test(path)
			return "workflow"
		else if /^\/?cms\b/.test(path)
			return "cms"
		else if /^\/?emailjs\b/.test(path)
			return "emailjs"
		else if /^\/?contacts\b/.test(path)
			return "contacts"
		else if /^\/?portal\b/.test(path)
			return "portal"
		else if /^\/?admin\b/.test(path)
			return "admin"
		else if /^\/?springboard\b/.test(path)
			return "springboard"
		else if /^\/?dashboard\b/.test(path)
			return "dashboard"
		else
			return ""

	getUserId: ()->
		return Meteor.userId()

	setAppTitle: (title)->
		Session.set("app_title", title);
		document.title = title;
		
	getLocale: ()->
		return Session.get("steedos-locale")

	# （1）1小时之内的，显示为 “＊分钟前”，鼠标移动到时 显示日期
	# （2）1-24小时之内的，显示为 “＊小时前”，鼠标移动到时 显示日期
	# （3）当年的 ，显示为 “月－日”如“2-20”
	# （4）去年及之前的，显示为“年－月－日”如“2015-4-20”
	momentFromNow: (time)->
		unless time instanceof Date
			return ""
		now = new Date()
		hoursPart = Math.floor((now.getTime() - time.getTime())/(60*60*1000))
		timeMoment = moment(time)
		if hoursPart < 24
			return timeMoment.fromNow()
		else if now.getFullYear() == time.getFullYear()
			return timeMoment.format('MM-DD')
		else
			return timeMoment.format('YYYY-MM-DD')

	# 1分钟更新一次moment结果
	momentReactiveFromNow: (time)->
		Steedos.deps?.miniute?.depend()
		return Steedos.momentFromNow(time)

	afModalInsert: ->
		return t "afModal_insert"

	afModalUpdate: ->
		return t "afModal_update"

	afModalRemove: ->
		return t "afModal_remove"

	afModalCancel: ->
		return t "afModal_cancel"

_.extend Steedos, Steedos.Helpers

Template.registerHelpers = (dict) ->
	_.each dict, (v, k)->
		Template.registerHelper k, v

Template.registerHelpers Steedos.Helpers
