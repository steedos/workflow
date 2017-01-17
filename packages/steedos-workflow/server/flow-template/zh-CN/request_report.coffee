
# 请示报告
workflowTemplate["zh-CN"].push {
	"_id": "EBCA7988-F527-4F1E-9B2E-302FE20707CC",
	"name": "请示报告",
	"state": "enabled",
	"is_deleted": false,
	"is_valid": true,
	"space": "526621803349041651000a1a",
	"created": "2014-02-27T08:44:24.119Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "3ba32fcf-bcb7-4d65-8eec-7034b7154240",
		"_rev": 2,
		"created": "2014-03-04T08:38:16.397Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2015-10-29T06:58:29.448Z",
		"modified_by": "521c5ab612efd2040700006d",
		"start_date": "2014-03-04T08:38:22.276Z",
		"form": "EBCA7988-F527-4F1E-9B2E-302FE20707CC",
		"fields": [
			{
				"_id": "FF71BA9E-C257-42C0-BCE6-E2F9E406B36D",
				"code": "请示内容",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "请示内容"
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
			"_id": "71737EFC-BC81-48B8-8B3D-D1F3FB62DB67",
			"name": "请示报告",
			"code_formula": "",
			"space": "526621803349041651000a1a",
			"description": "",
			"is_valid": true,
			"form": "EBCA7988-F527-4F1E-9B2E-302FE20707CC",
			"flowtype": "new",
			"state": "enabled",
			"created": "2014-02-27T08:46:01.919Z",
			"created_by": "519978e28e296a2fef000012",
			"help_text": "",
			"is_deleted": false,
			"app": "workflow",
			"current": {
				"_id": "bc9523a9-0beb-4628-931a-17861183cd28",
				"_rev": 2,
				"flow": "71737EFC-BC81-48B8-8B3D-D1F3FB62DB67",
				"form_version": "3ba32fcf-bcb7-4d65-8eec-7034b7154240",
				"modified": "2014-03-04T08:38:28.068Z",
				"modified_by": "519978e28e296a2fef000012",
				"created": "2014-03-04T08:38:16.397Z",
				"created_by": "519978e28e296a2fef000012",
				"start_date": "2014-03-04T08:38:28.068Z",
				"steps": [
					{
						"_id": "3086E012-E95F-415F-B19A-82BD8B90A42C",
						"name": "开始填写",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 125,
						"posy": 189,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"__form": "editable",
							"请示内容": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "DD855EC6-7C4E-4622-9B2A-B11C07FD33EB",
								"name": "",
								"state": "submitted",
								"to_step": "f3d5587d-3c4a-446a-8475-756add4badb2",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "FF8EB3E5-5C07-4220-830D-09C9B7DD5BDF",
						"name": "结束",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 574,
						"posy": 190,
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
						"_id": "f3d5587d-3c4a-446a-8475-756add4badb2",
						"name": "部门经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 279,
						"posy": 189,
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
								"_id": "10301064-5070-43c5-bf9f-faad0ef4b1dc",
								"name": "",
								"state": "approved",
								"to_step": "155d66b5-9128-4bbc-9930-65c1fe6959d2",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "155d66b5-9128-4bbc-9930-65c1fe6959d2",
						"name": "总经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 423,
						"posy": 188,
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
								"_id": "83afe538-0d07-43f2-b705-df3d2824ec7e",
								"name": "",
								"state": "approved",
								"to_step": "FF8EB3E5-5C07-4220-830D-09C9B7DD5BDF",
								"description": ""
							}
						],
						"approver_roles_name": []
					}
				]
			},
			"current_no": 8,
			"name_formula": "",
			"historys": []
		}
	]
}