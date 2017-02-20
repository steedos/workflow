Portal = 
	GetAuthByName: (auth_name,space_id,user_id) ->
		space = if space_id then space_id else Session.get("spaceId")
		user = if user_id then user_id else Meteor.userId()
		return db.apps_auth_users.findOne({space:space,user:user,auth_name:auth_name})

# Portal Freeboard设置中datasources变量保存到全局变量Portal.Datasources中
# 语法为：Portal.Datasources["{{dashboard_id}}"]["{{datasources_name}}"]
# 例如：Portal.Datasources["7jqC9JWqmrG4azMR5"]["EXPENSE_CNPC_GetMyTask"]
Portal.Datasources = {}

# Portal Freeboard设置中的widget模板脚本里面允许定义事件，事件函数变量名保存到全局变量Portal.Events中
# 定义函数语法为：Portal.Events.on_click_fun=function(){...};Portal.Events.try_to_login=function(){...};...
# 绑定事件通常的写法为：<a href="..." onclick="Portal.Events.try_to_login()"></a>
Portal.Events = {
	callBackForAjax: () ->
}
