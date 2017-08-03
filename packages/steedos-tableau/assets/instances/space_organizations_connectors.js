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
			alias: "",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "name",
			alias: "名称",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "fullname",
			alias: "全名",
			dataType: tableau.dataTypeEnum.int
		}, {
			id: "is_company",
			alias: "是否公司",
			dataType: tableau.dataTypeEnum.int
		}, {
			id: "parents",
			alias: "父部门",
			dataType: tableau.dataTypeEnum.int
		}, {
			id: "chidren",
			alias: "子部门",
			dataType: tableau.dataTypeEnum.int
		}, {
			id: "users",
			alias: "部门人员",
			dataType: tableau.dataTypeEnum.int
		}, {
			id: "sort_no",
			alias: "排序号",
			dataType: tableau.dataTypeEnum.int
		}];

		var instancesTableSchema = {
			id: "spaceInstances_cost_time",
			alias: "space instances users cost time",
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

		// if (last_sync_token > 0)
		// 	url_params =  url_params + "&sync_token=" + last_sync_token;

		console.log("instancesConnector.getData...")

		url = window.location.origin + "/api/workflow/instances/space/" + spaceId + "/approves/cost_time" + url_params

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
					instances.forEach(function (ins) {

						var ins_item = {};

						ins_item.sync_token = sync_token

						ins_item.handler_name = ins._id.handler_name

						ins_item.handler = ins._id.handler

						ins_item.avg_cost_time = ins.avg_cost_time

						ins_item.count = ins.count

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

		tableau.connectionData = JSON.stringify(connectionData);
		tableau.submit();
	};

	tableau.registerConnector(instancesConnector);

// Create event listeners for when the user submits the form
	$(document).ready(function () {
		$("#submitButton").click(function () {

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
