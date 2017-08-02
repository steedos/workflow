/**
 * Created by dell on 2017/5/19.
 */
(function () {
	// Create the connector object
	var instancesConnector = tableau.makeConnector();

	instancesConnector.init = function (initCallback) {
		tableau.authType = tableau.authTypeEnum.basic;
		initCallback();
	}

// Define the schema
	instancesConnector.getSchema = function (schemaCallback) {
		var insCols = [{
			id: "_id",
			alias: "审批Id",
			dataType: tableau.dataTypeEnum.string
		},{
			id: "ins_id",
			alias: "申请单Id",
			dataType: tableau.dataTypeEnum.string
		},{
			id: "flow",
			alias: "流程名称",
			dataType: tableau.dataTypeEnum.string
		},{
			id: "step_name",
			alias: "步骤名称",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "handler_name",
			alias: "处理人姓名",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "handler",
			alias: "处理人",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "start_date",
			alias: "接收时间",
			dataType: tableau.dataTypeEnum.datetime
		}, {
			id: "cost_time",
			alias: "审批耗时/毫秒",
			dataType: tableau.dataTypeEnum.int
		},{
			id: "is_finished",
			alias: "是否已审批",
			dataType: tableau.dataTypeEnum.bool
		},{
			id: "type",
			alias: "审批类型",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "sync_token",
			alias: "同步时间",
			dataType: tableau.dataTypeEnum.int
		}];

		var instancesTableSchema = {
			id: "spaceInstances_cost_time",
			alias: "审批耗时明细",
			columns: insCols,
			incrementColumnId: "sync_token"
		};

		schemaCallback([instancesTableSchema]);
	};

// Download the data
	instancesConnector.getData = function (table, doneCallback) {

		// var last_sync_token = parseInt(table.incrementValue || 0);

		var connectionData = JSON.parse(tableau.connectionData);

		var spaceId = connectionData.spaceId;

		var period = connectionData.period;

		var username = tableau.username

		var password = tableau.password

		var url_params = "?username=" + username + "&password=" + password + "&period=" + period;

		url_params = url_params + "&orgs=" + connectionData.instance_approves_hanlder_orgs

		// if (last_sync_token > 0)
		// 	url_params =  url_params + "&sync_token=" + last_sync_token;

		console.log("instancesConnector.getData...")

		url = window.location.origin + "/api/workflow/instances/space/" + spaceId + "/approves/cost_time/details" + url_params

		settings = {
			url: url,
			type: 'GET',
			crossDomain: true,
			async: false,
			dataType: 'json',
			processData: false,
			contentType: "application/json",
			success: function (resp, textStatus) {

				console.log("resp.data:", resp.data.length)

				var instances = resp.data
				var tableData = [];

				var sync_token = resp.sync_token

				if (table.tableInfo.id == "spaceInstances_cost_time") {
					instances.forEach(function (approve) {

						var ins_item = {};

						ins_item.sync_token = sync_token

						ins_item._id = approve._id
						ins_item.ins_id = approve.ins_id
						ins_item.flow = approve.flow
						ins_item.step_name = approve.step_name
						ins_item.handler_name = approve.handler_name
						ins_item.handler = approve.handler
						ins_item.start_date = new Date(approve.start_date)

						ins_item.cost_time = approve.cost_time

						ins_item.is_finished = approve.is_finished

						if(!ins_item.is_finished)
							ins_item.cost_time = ins_item.sync_token - ins_item.start_date.getTime()

						ins_item.type = approve.type

						tableData.push(ins_item)
					})
				}

				table.appendRows(tableData);
				doneCallback();
			}
		}

		$.ajax(settings)
	};

	setupConnector = function () {

		var connectionData = {};

		// var states = []
		//
		// $("[name='state']:checked").each(function(){states.push($(this).val())})
		//
		// connectionData.state = states.join(",")

		var spaceId = $("#spaceId").val();

		if(spaceId){
			connectionData.spaceId = spaceId;
		}

		alert("111" + $("#instance_approves_hanlder_orgs").val());

		connectionData.instance_approves_hanlder_orgs = $("#instance_approves_hanlder_orgs").val();

		tableau.connectionData = JSON.stringify(connectionData);
		tableau.submit();
	};

	tableau.registerConnector(instancesConnector);

// Create event listeners for when the user submits the form
	$(document).ready(function () {
		$("#submitButton").click(function () {
			alert("222" + $("#instance_approves_hanlder_orgs").val());
			var username = $("#username").val();
			if (!username) {
				alert("请填写username")
				return;
			}

			var password = $("#password").val();

			if (!password) {
				alert("请填写password")
				return;
			}

			var connName = $("#connName").val();

			if (!connName) {
				alert("请填写链接名称")
				return;
			}

			tableau.username = username;
			tableau.password = password;

			setupConnector();
			tableau.connectionName = connName; // This will be the data source name in Tableau
			tableau.submit(); // This sends the connector object to Tableau
		});
	});
})();
