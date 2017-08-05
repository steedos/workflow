/**
 * Created by dell on 2017/5/19.
 */
(function () {
	// Create the connector object
	var instancesConnector = tableau.makeConnector();

	instancesConnector.init = function (initCallback) {
		// tableau.authType = tableau.authTypeEnum.basic;
		initCallback();
	}

// Define the schema
	instancesConnector.getSchema = function (schemaCallback) {
		var insCols = [{
			id: "handler_organization_fullname",
			alias: "处理人部门",
			dataType: tableau.dataTypeEnum.string
		},{
			id: "handler_name",
			alias: "处理人姓名",
			dataType: tableau.dataTypeEnum.string
		},{
			id: "avg_cost_time",
			alias: "平均审批耗时/小时",
			dataType: tableau.dataTypeEnum.float
		},{
			id: "approve_count",
			alias: "审批次数",
			dataType: tableau.dataTypeEnum.int
		}];

		var instancesTableSchema = {
			id: "spaceInstances_cost_time",
			alias: "审批效率统计",
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

		var xUserId = connectionData.userId

		var xuserToken = connectionData.authToken

		var url_params = "?period=" + period;

		url_params = url_params + "&orgs=" + connectionData.instance_approves_hanlder_orgs

		url = window.location.origin + "/api/workflow/instances/space/" + spaceId + "/approves/cost_time" + url_params

		settings = {
			url: url,
			type: 'GET',
			headers: {
				"x-user-id": xUserId,
				"x-auth-token": xuserToken
			},
			crossDomain: true,
			async: false,
			dataType: 'json',
			processData: false,
			contentType: "application/json",
			success: function (resp, textStatus) {

				var instances = resp.data
				var tableData = [];

				var sync_token = resp.sync_token

				if (table.tableInfo.id == "spaceInstances_cost_time") {
					instances.forEach(function (approve) {

						var ins_item = {};

						ins_item.handler_organization_fullname = approve._id.handler_organization_fullname

						ins_item.handler_name = approve._id.handler_name

						ins_item.avg_cost_time = approve.avg_cost_time / 1000 / 60 / 60

						ins_item.approve_count = approve.approve_count

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

		var connectionData = JSON.parse(tableau.connectionData) || {};

		var spaceId = $("#spaceId").val();

		if(spaceId){
			connectionData.spaceId = spaceId;
		}

		connectionData.instance_approves_hanlder_orgs = $("#instance_approves_hanlder_orgs").val();

		connectionData.period = $("#period").val();

		tableau.connectionData = JSON.stringify(connectionData);
	};

	tableau.registerConnector(instancesConnector);

// Create event listeners for when the user submits the form
	$(document).ready(function () {
		$("#submitButton").click(function () {

			var connName = $("#connName").val();

			if (!connName) {
				$(".help-block").html("请填写链接名称")
				return;
			}

			if (!$("#instance_approves_hanlder_orgs").val()) {
				$(".help-block").html("请选择部门")
				return;
			}

			setupConnector();
			tableau.connectionName = connName; // This will be the data source name in Tableau
			tableau.submit(); // This sends the connector object to Tableau
		});
	});
})();
