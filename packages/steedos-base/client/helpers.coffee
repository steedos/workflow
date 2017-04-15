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

_.extend Steedos, Steedos.Helpers

Template.registerHelpers = (dict) ->
	_.each dict, (v, k)->
		Template.registerHelper k, v

Template.registerHelpers Steedos.Helpers
