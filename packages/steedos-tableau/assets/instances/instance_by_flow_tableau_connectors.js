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
			id: "_id",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "name",
			alias: "申请单名称",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "space",
			alias: "工作区",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "flow",
			alias: "流程",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "form",
			alias: "表单",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "applicant_name",
			alias: "申请人姓名",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "submit_date",
			alias: "提交时间",
			dataType: tableau.dataTypeEnum.datetime
		}, {
			id: "created",
			alias: "创建时间",
			dataType: tableau.dataTypeEnum.datetime
		}, {
			id: "modified",
			alias: "修改时间",
			dataType: tableau.dataTypeEnum.datetime
		}, {
			id: "state",
			alias: "状态",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "applicant_organization_name",
			alias: "申请人部门",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "applicant_organization_fullname",
			alias: "申请人部门",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "applicant",
			alias: "申请人",
			dataType: tableau.dataTypeEnum.string
		}, {
			id: "sync_token",
			alias: "同步时间",
			dataType: tableau.dataTypeEnum.int
		}];

		var approvesCols = [
			{
				id: "_id",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "instance",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "trace",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "step",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "stepName",
				alias: "步骤名称",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "is_finished",
				alias: "已处理",
				dataType: tableau.dataTypeEnum.bool
			}, {
				id: "user",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "user_name",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "handler",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "handler_name",
				alias: "处理人姓名",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "handler_organization",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "handler_organization_fullname",
				alias: "处理人部门",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "type",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "start_date",
				alias: "开始时间",
				dataType: tableau.dataTypeEnum.datetime
			}, {
				id: "read_date",
				alias: "查看时间",
				dataType: tableau.dataTypeEnum.datetime
			}, {
				id: "judge",
				dataType: tableau.dataTypeEnum.string
			}, {
				id: "finish_date",
				alias: "结束时间",
				dataType: tableau.dataTypeEnum.datetime
			}, {
				id: "cost_time",
				alias: "审批耗时",
				dataType: tableau.dataTypeEnum.int
			}, {
				id: "sync_token",
				alias: "同步时间",
				dataType: tableau.dataTypeEnum.int
			}
		]

		var connectionData = JSON.parse(tableau.connectionData);

		var valueFields = connectionData.valueFields

		if (valueFields) {
			insCols = insCols.concat(valueFields)
		}

		var instancesTableSchema = {
			id: "spaceInstances",
			alias: "space instances",
			columns: insCols,
			incrementColumnId: "sync_token"
		};

		var approvesTableSchema = {
			id: "spaceInstanceApproves",
			alias: "space instances approves",
			columns: approvesCols,
			incrementColumnId: "sync_token"
		};

		schemaCallback([instancesTableSchema, approvesTableSchema]);
	};

// Download the data
	instancesConnector.getData = function (table, doneCallback) {

		var last_sync_token = parseInt(table.incrementValue || 0);

		var connectionData = JSON.parse(tableau.connectionData);

		var valueFields = connectionData.valueFields;

		if (!valueFields) {
			valueFields = [];
		}

		SteedosTableau.getWorkflowInstanceData(last_sync_token, tableau.connectionData, function (resp, textStatus) {
			var instances = resp.data
			var tableData = [];

			var sync_token = resp.sync_token

			if (table.tableInfo.id === "spaceInstances") {
				instances.forEach(function (ins) {

					insVal = ins.values;

					ins.submit_date = new Date(ins.submit_date)

					ins.created = new Date(ins.created)

					ins.modified = new Date(ins.modified)

					ins.sync_token = sync_token

					valueFields.forEach(function (field) {
						fieldVal = insVal[field.code]
						if (!fieldVal) {
							fieldVal = "";
						}
						// switch(field.type){
						// 	case 'bool':
						//
						// }

						ins[field.id] = fieldVal
					})

					tableData.push(ins);
				});
			}

			if (table.tableInfo.id === "spaceInstanceApproves") {
				instances.forEach(function (ins) {
					if (!ins.traces)
						return;

					ins.traces.forEach(function (trace) {
						var stepId = trace.step;
						var stepName = trace.name

						if (trace.approves) {
							trace.approves.forEach(function (approve) {

								var item = {}

								item._id = approve._id

								item.instance = approve.instance

								item.trace = approve.trace

								item.step = stepId

								item.stepName = stepName

								item.is_finished = approve.is_finished

								item.user = approve.user

								item.user_name = approve.user_name

								item.handler = approve.handler

								item.handler_name = approve.handler_name

								item.handler_organization = approve.handler_organization

								item.handler_organization_fullname = approve.handler_organization_fullname

								item.type = approve.type

								item.start_date = new Date(approve.start_date)

								if (approve.read_date) {
									item.read_date = new Date(approve.read_date)
								}

								if (approve.finish_date) {
									item.finish_date = new Date(approve.finish_date)
								}

								item.judge = approve.judge

								item.cost_time = approve.cost_time

								item.sync_token = sync_token

								tableData.push(item);
							});
						}
					});
				});
			}

			table.appendRows(tableData);
			doneCallback();
		});
	};

	setupConnector = function () {
		var flowId = $("#flowId").val();

		if (flowId) {
			var connectionData = {
				"flowId": flowId
			};

			var valueFields = $("#valueFields").val();

			if (valueFields) {
				connectionData.valueFields = JSON.parse(valueFields);
			}

			connectionData.period = $("#period").val();

			var approve = $("#approve").is(':checked');

			connectionData.approve = approve;

			var states = []

			$("[name='state']:checked").each(function(){states.push($(this).val())})

			connectionData.state = states.join(",")

			connectionData.access_token = SteedosTableau.access_token;

			var spaceId = $("#spaceId").val();

			if(spaceId){
				connectionData.spaceId = spaceId;
			}

			tableau.connectionData = JSON.stringify(connectionData);
		}
	};

	tableau.registerConnector(instancesConnector);

// Create event listeners for when the user submits the form
	$(document).ready(function () {
		$("#submitButton").click(function () {
			var flowId = $("#flowId").val();

			if (!flowId) {
				alert("请填写流程Id")
				return;
			}

			var connName = $("#connName").val();

			if (!connName) {
				connName = flowId;
			}

			setupConnector();

			tableau.connectionName = connName; // This will be the data source name in Tableau

			tableau.submit(); // This sends the connector object to Tableau
		});
	});
})();
