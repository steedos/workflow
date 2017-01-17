
# 请假申请
workflowTemplate["zh-CN"].push {
	"_id": "CA8550DD-8A9A-4F7D-823A-A488CC0EBEA4",
	"name": "请假申请",
	"state": "enabled",
	"is_deleted": false,
	"is_valid": true,
	"space": "526621803349041651000a1a",
	"created": "2013-10-22T07:14:30.296Z",
	"created_by": "5199da558e296a4ba0000001",
	"current": {
		"_id": "189a49ed-f45f-4e23-9503-9e4ba41189e1",
		"_rev": 4,
		"created": "2013-11-28T09:25:11.013Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2015-10-29T06:58:38.671Z",
		"modified_by": "521c5ab612efd2040700006d",
		"start_date": "2014-03-04T08:37:46.334Z",
		"finish_date": "2014-03-04T08:37:39.280Z",
		"form": "CA8550DD-8A9A-4F7D-823A-A488CC0EBEA4",
		"fields": [
			{
				"_id": "A60FDA47-828E-4ABD-AF08-9E944EC570F0",
				"name": "",
				"code": "请假类别",
				"default_value": "",
				"is_required": true,
				"is_wide": false,
				"type": "select",
				"rows": 4,
				"digits": 0,
				"options": "事假\n病假\n年假\n调休\n婚假\n产假\n产检假\n丧假",
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "CF191507-89E0-498A-9BBA-55C065C38250",
				"name": "",
				"code": "请假天数",
				"is_required": true,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 1,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "ECACABE1-17DB-4E34-A6E3-8D320E9AFC87",
				"name": "",
				"code": "开始时间",
				"is_required": true,
				"is_wide": false,
				"type": "dateTime",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "BAACA98D-B1C7-4C7E-AF10-68EA5221E437",
				"name": "",
				"code": "结束时间",
				"is_required": true,
				"is_wide": false,
				"type": "dateTime",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "9F75C08F-822F-456C-9AEC-37C8EF10CCF0",
				"name": "",
				"code": "请假理由",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			}
		]
	},
	"enable_workflow": false,
	"enable_view_others": false,
	"app": "workflow",
	"is_subform": false,
	"approve_on_create": false,
	"approve_on_modify": false,
	"approve_on_delete": false,
	"historys": [],
	"flows": [
		{
			"_id": "67A0D684-EE13-49F0-9070-885483235911",
			"name": "请假申请",
			"name_formula": "",
			"code_formula": "",
			"space": "526621803349041651000a1a",
			"description": "",
			"is_valid": true,
			"form": "CA8550DD-8A9A-4F7D-823A-A488CC0EBEA4",
			"flowtype": "new",
			"state": "enabled",
			"is_deleted": false,
			"created": "2013-10-22T07:47:16.755Z",
			"created_by": "5199da558e296a4ba0000001",
			"help_text": "",
			"current_no": 20,
			"current": {
				"_id": "13bc34d4-aee2-476f-bf1f-cfc3babcc542",
				"_rev": 15,
				"flow": "67A0D684-EE13-49F0-9070-885483235911",
				"form_version": "189a49ed-f45f-4e23-9503-9e4ba41189e1",
				"modified": "2016-05-24T09:23:30.311Z",
				"modified_by": "521c5ab612efd2040700006d",
				"created": "2016-05-24T09:23:25.217Z",
				"created_by": "521c5ab612efd2040700006d",
				"start_date": "2016-05-24T09:23:25.217Z",
				"steps": [
					{
						"_id": "2D940E77-D250-4DA7-A913-F6AAFB6468BD",
						"name": "开始填写",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 40.1666641235352,
						"posy": 216.666667938232,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"fields_modifiable": [],
						"permissions": {
							"请假类别": "editable",
							"请假天数": "editable",
							"开始时间": "editable",
							"结束时间": "editable",
							"请假理由": "editable"
						},
						"lines": [
							{
								"_id": "3C136741-D5DD-4050-A629-8B39B546B5D4",
								"name": "",
								"state": "submitted",
								"to_step": "caf1decc-c63e-46fe-bd6b-0233f0eec91e",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "caf1decc-c63e-46fe-bd6b-0233f0eec91e",
						"name": "部门经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 150,
						"posy": 215,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"fields_modifiable": [],
						"permissions": {},
						"lines": [
							{
								"_id": "8d60d39f-1cd5-4a2e-bfcc-cde2bea8b9f0",
								"name": "",
								"state": "approved",
								"to_step": "9db4b7dd-5fbc-4fec-a052-0eac5bd6fc3f",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "9db4b7dd-5fbc-4fec-a052-0eac5bd6fc3f",
						"name": "总经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 320,
						"posy": 214,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"fields_modifiable": [],
						"permissions": {},
						"lines": [
							{
								"_id": "9ba7a1eb-9d63-45a4-a058-4780e81bbab6",
								"name": "",
								"state": "approved",
								"to_step": "5eb73f03-6407-4a01-b319-db9e5e75942d",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "5eb73f03-6407-4a01-b319-db9e5e75942d",
						"name": "人力资源部审核",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 488,
						"posy": 215,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"fields_modifiable": [],
						"permissions": {},
						"lines": [
							{
								"_id": "0920b7aa-a1e3-45dc-bdf3-ece88cfebed3",
								"name": "",
								"state": "approved",
								"to_step": "F31AC347-6590-45B1-A622-3B03966648C7",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "F31AC347-6590-45B1-A622-3B03966648C7",
						"name": "结束",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 644,
						"posy": 214,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"fields_modifiable": [],
						"permissions": {},
						"approver_roles_name": []
					}
				]
			},
			"app": "workflow",
			"historys": []
		}
	]
}