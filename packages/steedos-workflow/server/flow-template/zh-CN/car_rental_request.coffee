# 外出用车申请
workflowTemplate["zh-CN"].push {
	"_id": "CF0F36C9-FB18-4DB7-823C-3F35C07A1B5A",
	"name": "外出用车申请",
	"state": "enabled",
	"is_deleted": false,
	"is_valid": true,
	"space": "526621803349041651000a1a",
	"created": "2014-02-27T01:51:56.435Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "67d3f178-78fa-4919-a309-d6c8a4ecccad",
		"_rev": 3,
		"created": "2014-03-04T08:35:44.636Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2015-10-29T06:58:17.173Z",
		"modified_by": "521c5ab612efd2040700006d",
		"start_date": "2014-03-17T09:11:27.604Z",
		"finish_date": "2014-03-17T09:11:18.065Z",
		"form": "CF0F36C9-FB18-4DB7-823C-3F35C07A1B5A",
		"fields": [
			{
				"_id": "F8F76E7A-E54D-4A66-91C8-C11D07D23E83",
				"code": "使用何种车辆",
				"default_value": "",
				"is_required": true,
				"is_wide": false,
				"type": "select",
				"rows": 4,
				"digits": 0,
				"options": "公司车\n个人车",
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "使用何种车辆"
			},
			{
				"_id": "D91876CC-0B0C-4BA0-B08E-932A6ED13C6F",
				"code": "车辆归属人",
				"is_required": false,
				"is_wide": false,
				"type": "user",
				"rows": 1,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "车辆归属人"
			},
			{
				"_id": "275F9287-8DFC-4083-A014-1F088FA99F29",
				"code": "乘车人员",
				"is_required": true,
				"is_wide": false,
				"type": "user",
				"rows": 1,
				"digits": 0,
				"has_others": false,
				"is_multiselect": true,
				"subform_fields": [],
				"oldCode": "乘车人员"
			},
			{
				"_id": "3B342FE5-CE26-495C-B743-63879DB60892",
				"code": "行程明细",
				"is_required": false,
				"is_wide": true,
				"type": "table",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "行程明细",
				"fields": [
					{
						"_id": "32E2B2D3-0204-4664-B874-06B3A5A39508",
						"code": "出发时间",
						"is_required": true,
						"is_wide": false,
						"type": "dateTime",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "出发时间"
					},
					{
						"_id": "6F99A162-BF60-4EEC-962E-BC0A2A331EB0",
						"code": "返回时间",
						"is_required": true,
						"is_wide": false,
						"type": "dateTime",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "返回时间"
					},
					{
						"_id": "097212BF-9126-4E4B-B5EA-DEBFE96D69F6",
						"code": "出发地",
						"is_required": true,
						"is_wide": false,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "出发地"
					},
					{
						"_id": "062E0AD1-EB55-48AF-AF73-CB164FD45DF2",
						"code": "目的地",
						"is_required": true,
						"is_wide": false,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "目的地"
					},
					{
						"_id": "F9C8D8D7-1051-4C6F-9570-8581BB043E3C",
						"code": "事由",
						"is_required": false,
						"is_wide": false,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "事由"
					}
				]
			},
			{
				"_id": "7E2F077D-04B5-4A07-A78C-B707FC71EF66",
				"code": "合计行驶里程数",
				"is_required": true,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "合计行驶里程数"
			},
			{
				"_id": "F9832C18-94A8-44CC-A682-B7027C091E35",
				"code": "还车里程数",
				"is_required": false,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "还车里程数"
			},
			{
				"_id": "77993F6B-66B3-45F4-A95B-8FEA22BF09D7",
				"code": "备注",
				"is_required": false,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "备注"
			}
		]
	},
	"enable_workflow": false,
	"enable_view_others": false,
	"app": "workflow",
	"is_subform": false,
	"historys": [],
	"flows": [
		{
			"_id": "F1ACD590-B948-4056-94A8-0ED75570EDA1",
			"name": "外出用车申请",
			"code_formula": "",
			"space": "526621803349041651000a1a",
			"description": "",
			"is_valid": true,
			"form": "CF0F36C9-FB18-4DB7-823C-3F35C07A1B5A",
			"flowtype": "new",
			"state": "enabled",
			"created": "2014-02-27T02:05:39.328Z",
			"created_by": "519978e28e296a2fef000012",
			"help_text": "",
			"is_deleted": false,
			"app": "workflow",
			"current": {
				"_id": "2c37925f-861f-4873-abfb-8cec2fab1692",
				"_rev": 3,
				"flow": "F1ACD590-B948-4056-94A8-0ED75570EDA1",
				"form_version": "67d3f178-78fa-4919-a309-d6c8a4ecccad",
				"modified": "2015-05-04T06:16:30.541Z",
				"modified_by": "5199da568e296a4ba0000003",
				"created": "2014-03-04T08:35:44.636Z",
				"created_by": "519978e28e296a2fef000012",
				"start_date": "2014-03-17T09:11:30.836Z",
				"finish_date": "2014-03-17T09:11:17.243Z",
				"steps": [
					{
						"_id": "D66BBDF3-E14A-4761-A75E-749B7DBFA8F3",
						"name": "开始填写",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 120.75,
						"posy": 120,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"__form": "editable",
							"使用何种车辆": "editable",
							"车辆归属人": "editable",
							"乘车人员": "editable",
							"行程明细": "editable",
							"出发时间": "editable",
							"返回时间": "editable",
							"出发地": "editable",
							"目的地": "editable",
							"事由": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "17290CCD-8075-4CDF-9204-9FBA72B2778D",
								"name": "",
								"state": "submitted",
								"to_step": "3296d974-c0d5-46a2-b22e-83d8302ba82a",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "46A15ED6-FED6-4E6D-85B2-23B00252C84C",
						"name": "结束",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 621.25,
						"posy": 252,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {},
						"fields_modifiable": [],
						"approver_roles_name": []
					},
					{
						"_id": "3296d974-c0d5-46a2-b22e-83d8302ba82a",
						"name": "部门经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 268,
						"posy": 123,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "dbd831b9-8e0a-4d8f-ad9b-f134210ee4a5",
								"name": "",
								"state": "approved",
								"to_step": "d68be9c7-a71d-459c-885e-7ffcba34608f",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "d68be9c7-a71d-459c-885e-7ffcba34608f",
						"name": "总经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 438.99687500000005,
						"posy": 124.996875,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "13fe2ed8-a701-4de5-b55c-5c06817982fd",
								"name": "",
								"state": "approved",
								"to_step": "e9ed1cb3-73a2-427e-beb6-3218245e4e51",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "e9ed1cb3-73a2-427e-beb6-3218245e4e51",
						"name": "用车并登记里程数",
						"step_type": "submit",
						"deal_type": "applicant",
						"description": "",
						"posx": 419.00000000000006,
						"posy": 250,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"合计行驶里程数": "editable",
							"还车里程数": "editable",
							"备注": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "c21f29fb-c881-40ae-9a42-50dfe7d7d08b",
								"name": "",
								"state": "submitted",
								"to_step": "46A15ED6-FED6-4E6D-85B2-23B00252C84C",
								"description": ""
							}
						],
						"approver_roles_name": []
					}
				]
			},
			"current_no": 3,
			"name_formula": "",
			"historys": []
		}
	]
}