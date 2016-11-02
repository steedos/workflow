Template.adminSidebar.helpers

	displayName: ->

		if Meteor.user()
			return Meteor.user().displayName()
		else
			return " "
	 
	avatar: ->
		return Meteor.absoluteUrl("/avatar/" + Meteor.userId());

	spaceId: ->
		if Session.get("spaceId")
			return Session.get("spaceId")
		else
			return localStorage.getItem("spaceId:" + Meteor.userId())

	boxName: ->
		if Session.get("box")
			return t(Session.get("box"))

	boxActive: (box)->
		if box == Session.get("box")
			return "active"

	menuClass: (urlTag)->
		path = Session.get("router-path")
		if path?.startsWith "/" + urlTag or path?.startsWith "/steedos/" + urlTag
			return "active"

	isWorkflowAdmin: ()->
		if Steedos.isSpaceAdmin() then Steedos.getSpaceWorkflowApp() else false

	isPortalAdmin: ()->
		return Steedos.getSpacePortalApp()

	isCmsAdmin: ()->
		if Steedos.isSpaceAdmin() then Steedos.getSpaceCmsApp() else false

Template.adminSidebar.events

	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"

	'click .fix-collection-helper a': (event) ->
		# 因部分admin列表界面在进入路由的时候会出现控制台报错：data[a[i]] is not a function
		# 且只有从admin列表界面进入到admin列表界面时才可能会报上面的错误信息
		# 所以这里加上fix-collection-helper样式类内的a链接先额外跳转到一个非admin列表界面，然后再让其自动跳转到href界面，这样可以避开错误信息
		FlowRouter.go("/admin/profile")