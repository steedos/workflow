AppSSO =

	writeResponse: (res, httpCode, body)->
		res.statusCode = httpCode;
		res.end(body);
		
	sendInvalidURLResponse: (res)->
		return @writeResponse(res, 404, "url must be has querys as authToken,userId.");
		
	sendAuthTokenExpiredResponse: (res)->
		return @writeResponse(res, 401, "the auth_token has expired.");

	sendHtmlResponse: (req, res)->
		app_id = req.params.app_id
		query = req.query
		auth_token = query.authToken
		user_id = query.userId
		return_url = query.returnUrl

		unless auth_token and user_id
			AppSSO.sendInvalidURLResponse res

		hashedToken = Accounts._hashLoginToken(auth_token)
		user = Meteor.users.findOne
			_id: user_id,
			"services.resume.loginTokens.hashedToken": hashedToken
		unless user
			AppSSO.sendAuthTokenExpiredResponse res

		error_msg = ""

		app = db.apps.findOne {_id:app_id}
		if app
			if app.is_use_ie
				app_script = app.on_click
				if app_script
					# 这里需要把脚本中{{login_name}}及{{login_password}}替换成当前用户在域账户（即apps_auth_user）中设置的域账户及密码
					reg_login_name = /{{login_name}}/g
					reg_login_password = /{{login_password}}/g
					apps_auth_user = Portal.GetAuthByName app.auth_name, app.space, user_id
					if apps_auth_user
						login_name = apps_auth_user.login_name
						login_password = apps_auth_user.login_password
					else
						error_msg = "当前用户没有设置#{auth_name}域账户及密码"
						login_name = ""
						login_password = ""
					app_script = app_script.replace reg_login_name, login_name
					app_script = app_script.replace reg_login_password, login_password
					unless return_url
						return_url = ""
					# 当接口参数中提供了用于返回的return_url时，需要把脚本中return_url占位符替换成参数中的return_url
					reg_return_url = /{{return_url}}/g
					app_script = app_script.replace reg_return_url, return_url
				else
					error_msg = "当前应用的[链接脚本]属性内容为空，无法执行单点登录脚本"
					app_script = ""
			else
				error_msg = "当前应用的[使用IE打开]属性没有勾选，无法执行单点登录脚本"
				app_script = ""
		else
			error_msg = "当前应用不存在或已被删除"
			app_script = ""


		return @writeResponse res, 200, """
			<!DOCTYPE html>
			<html>
				<head>
					<meta charset="utf-8">
					<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
					<title>Steedos</title>
					<script type="text/javascript" src="/packages/steedos_portal/client/jquery/jquery-1.11.2.min.js"></script>
					<style>
						body { 
							background-color: #222d32;
							color:#fff;
							font-family: 'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif;
						}
						.loading{
							position: absolute;
							left: 0px;
							right: 0px;
							top: 50%;
							z-index: 1100;
							text-align: center;
							margin-top: -30px;
							font-size: 36px;
							color: #dfdfdf;
						}
						.error-msg{
							position: absolute;
							left: 0px;
							right: 0px;
							bottom: 20px;
							z-index: 1100;
							text-align: center;
							font-size: 20px;
							color: #a94442;
						}
					</style>
				</head>
				<body>
					<div class = "loading">Loading...</div>
					<div class = "error-msg">#{error_msg}</div>
					<script type="text/javascript">
						#{app_script}
					</script>
				</body>
			</html>
		"""



JsonRoutes.add 'get', '/api/app/sso/:app_id', (req, res, next) ->
	console.log 'fetching AppSSO from /api/app/sso: %s %s %s', (new Date).toJSON(), JSON.stringify(req.query), req.params.app_id
	AppSSO.sendHtmlResponse req, res


