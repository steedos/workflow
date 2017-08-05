SteedosTableau = {}

SteedosTableau.loginWithPassword = function (username, password) {

	data = {email: username, password: password}

	if (username.indexOf('@') == -1) {
		data = {user: username, password: password}
	}

	login = $.ajax({
		url: '/steedos/api/login',
		type: 'POST',
		async: false,
		data: data
	});

	if (login.status != 200) {
		return false
	} else {

		SteedosTableau.auth = login.responseJSON.data

		return login.responseJSON.data
	}
}


$(document).ready(function () {
	$("#login").click(function () {
		$(".help-block").html("")

		var username = $("#username").val();
		if (!username) {
			$(".help-block").html("请填写账户")
			return;
		}

		var password = $("#password").val();

		if (!password) {
			$(".help-block").html("请填写密码")
			return;
		}

		var authData = SteedosTableau.loginWithPassword(username, password);

		if (!authData) {
			$(".help-block").html("用户名或密码错误")
			return;
		}

		$(".steedos-tableau-auth").hide();
		$(".steedos-tableau-data").show();

		if (tableau) {
			tableau.connectionData = JSON.stringify(authData)
		}
	})
})