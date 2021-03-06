"use strict";
var SteedosTableau = {};
var getUrlParameter = function getUrlParameter(sParam) {
	var sPageURL = decodeURIComponent(window.location.search.substring(1)),
		sURLVariables = sPageURL.split('&'),
		sParameterName,
		i;

	for (i = 0; i < sURLVariables.length; i++) {
		sParameterName = sURLVariables[i].split('=');

		if (sParameterName[0] === sParam) {
			return sParameterName[1] === undefined ? true : sParameterName[1];
		}
	}
};

SteedosTableau.checkAccountsToken = function (access_token) {
	var checked = $.ajax({
		url: '/api/access/check?access_token=' + access_token,
		type: 'GET',
		async: false
	});

	if(checked.status === 200){
		return true;
	}else{
		$(".help-block").html("access_token已过期，请输入密码或重新复制链接");
		return false;
	}
};

SteedosTableau.loginWithPassword = function (username, password) {

	var data = {email: username, password: password};

	if (username.indexOf('@') === -1) {
		data = {user: username, password: password};
	}

	var login = $.ajax({
		url: '/steedos/api/login',
		type: 'POST',
		async: false,
		data: data
	});

	if (login.status !== 200) {
		return false;
	} else {

		SteedosTableau.auth = login.responseJSON.data;

		return login.responseJSON.data;
	}
};

SteedosTableau.getTokenWithPassword = function (username, password) {

	var data = {email: username, password: password};

	if (username.indexOf('@') === -1) {
		data = {user: username, password: password};
	}

	var getToken = $.ajax({
		url: '/tableau/access_token',
		type: 'POST',
		async: false,
		data: data
	});

	if (getToken.status !== 200) {
		return false;
	} else {

		return getToken.responseJSON.data.access_token;
	}
};

SteedosTableau.searchOrganizations = function (spaceId, data, callback) {
	$.ajax({
		url: '/tableau/search/space/' + spaceId + '/organizations?access_token=' + SteedosTableau.access_token,
		type: 'POST',
		async: false,
		data: JSON.stringify(data),
		contentType: "application/json",
		error: function() {
			$(".help-block").html("access_token已过期，请输入密码或重新复制链接");
			$(".steedos-tableau-data").hide();
			$(".steedos-tableau-auth").show();
			callback();
		},
		success: function(res) {
			callback(res);
		}
	});
};
SteedosTableau.searchFlows = function (spaceId, data, callback) {
	$.ajax({
		url: '/tableau/search/space/' + spaceId + '/flows?access_token=' + SteedosTableau.access_token,
		type: 'POST',
		async: false,
		data: JSON.stringify(data),
		contentType: "application/json",
		error: function() {
			$(".help-block").html("access_token已过期，请输入密码或重新复制链接");
			$(".steedos-tableau-data").hide();
			$(".steedos-tableau-auth").show();
			callback();
		},
		success: function(res) {
			callback(res);
		}
	});
};

SteedosTableau.getWorkflowCostTimeData = function (data, callback) {
	var connectionData = JSON.parse(data);

	var spaceId = connectionData.spaceId;

	var period = connectionData.period;

	var access_token = connectionData.access_token;

	var url_params = "?access_token=" + access_token;

	var json_data = {
		period: period,
		orgs: connectionData.instance_approves_hanlder_orgs,
		flows: connectionData.flows
	};

	var url = window.location.origin + "/tableau/api/workflow/instances/space/" + spaceId + "/approves/cost_time" + url_params;

	var settings = {
		url: url,
		type: 'POST',
		crossDomain: true,
		async: false,
		dataType: 'json',
		processData: false,
		data: JSON.stringify(json_data),
		contentType: "application/json",
		success: function (resp, textStatus) {
			callback(resp, textStatus);
		}
	};

	$.ajax(settings);
};

SteedosTableau.getWorkflowInstanceData = function (last_sync_token, data, callback) {

	var connectionData = JSON.parse(data);

	var flowId = connectionData.flowId;

	var access_token = connectionData.access_token;

	var spaceId = connectionData.spaceId;

	var approve = connectionData.approve;

	var state = connectionData.state;

	var period = connectionData.period;

	var url_params = "?access_token=" + access_token;

	if(approve){
		url_params = url_params + "&approve=true";
	}

	if(state){
		url_params = url_params + "&state=" + state;
	}

	if(period){
		url_params = url_params + "&period=" + period;
	}

	var valueFields = connectionData.valueFields;

	if (!valueFields) {
		valueFields = [];
	}

	if (last_sync_token > 0){
		url_params =  url_params + "&sync_token=" + last_sync_token;
	}

	var url = window.location.origin + "/tableau/api/workflow/instances/space/"+spaceId+"/flow/" + flowId + url_params;

	var settings = {
		url: url,
		type: 'GET',
		crossDomain: true,
		async: false,
		dataType: 'json',
		processData: false,
		contentType: "application/json",
		success: function (resp, textStatus) {
			callback(resp, textStatus);
		}
	};

	$.ajax(settings);
};

$(document).ready(function () {

	var access_token = getUrlParameter("access_token");

	if(access_token){
		var token_valid = SteedosTableau.checkAccountsToken(access_token);

		if(token_valid){

			SteedosTableau.access_token = access_token;

			$(".steedos-tableau-auth").hide();
			$(".steedos-tableau-data").show();
		}
	}

	$("#login").click(function () {
		$(".help-block").html("");

		var username = $("#username").val();
		if (!username) {
			$(".help-block").html("请填写账户");
			return;
		}

		var password = $("#password").val();

		if (!password) {
			$(".help-block").html("请填写密码");
			return;
		}

		var access_token = SteedosTableau.getTokenWithPassword(username, password);

		SteedosTableau.access_token = access_token;

		if (!access_token) {
			$(".help-block").html("用户名或密码错误");
			return;
		}

		$(".steedos-tableau-auth").hide();
		$(".steedos-tableau-data").show();
	});
});