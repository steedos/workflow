getUserAuthCode = (context, redirect) ->
	qiyeweixin = Meteor?.settings?.public?.qiyeweixin
	o = ServiceConfiguration.configurations.findOne({service: "qiyeweixin"})
	if o
		redirect_uri = encodeURIComponent Meteor.absoluteUrl('api/qiyeweixin/auth_login')
		appid = o.corpid
		authorize_uri = qiyeweixin.authorize_uri
		url = authorize_uri+'?appid='+appid+'&redirect_uri='+redirect_uri+'&response_type=code&scope=snsapi_base#wechat_redirect'
		window.location = url

FlowRouter.route '/steedos/qiyeweixin/mainpage',
	triggersEnter: [ getUserAuthCode ]