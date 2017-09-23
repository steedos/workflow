# 外出申请、报告
workflowTemplate["zh-CN"].push {
	"_id": "CA2A76B2-105D-4F47-8174-C508AFB293AD",
	"name": "外出申请、报告",
	"state": "enabled",
	"is_deleted": false,
	"is_valid": true,
	"space": "526621803349041651000a1a",
	"created": "2014-02-28T01:33:27.986Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "C93C1E5E-A073-4C7F-A2C9-EC453AB09A11",
		"_rev": 1,
		"created": "2014-02-28T01:33:27.986Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2015-09-23T05:11:45.216Z",
		"modified_by": "521c5ab612efd2040700006d",
		"start_date": "2014-03-04T08:36:15.143Z",
		"finish_date": "2014-03-04T08:36:06.432Z",
		"form": "CA2A76B2-105D-4F47-8174-C508AFB293AD",
		"fields": [
			{
				"_id": "2970B2DF-C77C-4AA4-A62B-B065601F9140",
				"code": "外出申请时间",
				"is_required": true,
				"is_wide": false,
				"type": "dateTime",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "外出申请时间",
				"subform_fields": []
			},
			{
				"_id": "431C623E-D47B-4569-BAD8-F561A73AC094",
				"code": "外出结束时间",
				"is_required": true,
				"is_wide": false,
				"type": "dateTime",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "外出结束时间",
				"subform_fields": []
			},
			{
				"_id": "19A5A568-F320-4C5A-84B0-D12E9CDCB327",
				"code": "外出天数",
				"is_required": true,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "外出天数",
				"subform_fields": []
			},
			{
				"_id": "DF0A237D-B117-4BE0-8295-FB0F766AEDB5",
				"code": "拜访单位名称",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "拜访单位名称",
				"subform_fields": []
			},
			{
				"_id": "03377010-7496-4828-BB0E-49BB165E60F4",
				"code": "拜访对象（含称谓）",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "拜访对象（含称谓）",
				"subform_fields": []
			},
			{
				"_id": "47B668B0-153B-4A44-A903-341F6FEA0F90",
				"code": "拜访目的",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "拜访目的",
				"subform_fields": []
			},
			{
				"_id": "D900111A-4A67-4E1A-B16A-ED5075607CC9",
				"code": "行程安排",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "行程安排",
				"subform_fields": []
			},
			{
				"_id": "93AA658D-A56F-47DC-ABA4-D2BBA656B5CF",
				"code": "交通工具安排",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "交通工具安排",
				"subform_fields": []
			},
			{
				"_id": "D213F20B-45E9-4A33-AF84-2EE496BCBB32",
				"code": "拜访总结及下一步计划（外出返回后填写）",
				"is_required": true,
				"is_wide": true,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "拜访总结及下一步计划（外出返回后填写）",
				"subform_fields": []
			},
			{
				"_id": "C03DE44D-CBBE-41B8-853E-A6AF8ABD30E8",
				"code": "外出费用",
				"is_required": true,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 2,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "外出费用",
				"subform_fields": []
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
			"_id": "4D0A8A30-02EA-40A6-921D-69DA1BC4A04E",
			"name": "外出申请、报告",
			"code_formula": "",
			"space": "526621803349041651000a1a",
			"description": "",
			"is_valid": true,
			"form": "CA2A76B2-105D-4F47-8174-C508AFB293AD",
			"flowtype": "new",
			"state": "enabled",
			"created": "2014-02-28T02:12:14.462Z",
			"created_by": "519978e28e296a2fef000012",
			"help_text": "",
			"is_deleted": false,
			"app": "workflow",
			"current": {
				"_id": "86140eb8-1c18-46fa-8e89-a5a8057f7d91",
				"_rev": 2,
				"flow": "4D0A8A30-02EA-40A6-921D-69DA1BC4A04E",
				"form_version": "C93C1E5E-A073-4C7F-A2C9-EC453AB09A11",
				"modified": "2014-03-04T08:36:19.395Z",
				"modified_by": "519978e28e296a2fef000012",
				"created": "2014-02-28T02:59:01.481Z",
				"created_by": "519978e28e296a2fef000012",
				"start_date": "2014-03-04T08:36:19.395Z",
				"finish_date": "2014-03-04T08:36:03.462Z",
				"steps": [
					{
						"_id": "75772231-43EB-4F7C-9816-F95CA4BDF60A",
						"name": "开始填写",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 118,
						"posy": 64,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"__form": "editable",
							"外出申请时间": "editable",
							"外出结束时间": "editable",
							"外出天数": "editable",
							"拜访单位名称": "editable",
							"拜访对象（含称谓）": "editable",
							"拜访目的": "editable",
							"行程安排": "editable",
							"交通工具安排": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "28DE680C-C77C-4986-A485-F477AE4DA1A2",
								"name": "",
								"state": "submitted",
								"to_step": "b7aabec8-9ec9-45c9-a42e-04f79f09bfe9",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "F6C0ADBE-E24B-4A13-93FD-1BB6409A961B",
						"name": "结束",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 786,
						"posy": 484,
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
						"_id": "b7aabec8-9ec9-45c9-a42e-04f79f09bfe9",
						"name": "部门经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 253,
						"posy": 67,
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
								"_id": "34c14118-ef9e-4df3-8d6f-3da0cb0685a4",
								"name": "",
								"state": "approved",
								"to_step": "2d3d35f8-7d0e-431d-87e1-cf7920395c0d",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "2d3d35f8-7d0e-431d-87e1-cf7920395c0d",
						"name": "总经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 424,
						"posy": 66,
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
								"_id": "e624f7e4-8ad2-4a7b-b0d7-32454748bfb1",
								"name": "",
								"state": "approved",
								"to_step": "4af30696-f1e6-4700-84a1-641eb2335f07",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "4af30696-f1e6-4700-84a1-641eb2335f07",
						"name": "拜访总结及下一步计划",
						"step_type": "submit",
						"deal_type": "applicant",
						"description": "",
						"posx": 392,
						"posy": 200,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"拜访总结及下一步计划（外出返回后填写）": "editable",
							"外出费用": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "902d222c-5712-4259-a23a-79154823da8c",
								"name": "",
								"state": "submitted",
								"to_step": "3a258742-5acd-434f-8f4e-6bc54cfab011",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "3a258742-5acd-434f-8f4e-6bc54cfab011",
						"name": "部门经理确认",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 591,
						"posy": 209,
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
								"_id": "2e3bdf13-5a2a-4b81-83de-02cec1d42111",
								"name": "",
								"state": "approved",
								"to_step": "d8785a16-6d11-4b53-b257-fcedf0d7bdec",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "d8785a16-6d11-4b53-b257-fcedf0d7bdec",
						"name": "总经理确认",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 599,
						"posy": 358,
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
								"_id": "2aeadbe2-5fd7-4710-84e0-d3a66d1e7378",
								"name": "",
								"state": "approved",
								"to_step": "4d3aac3d-169a-415c-bd4b-c59d919b8dda",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "4d3aac3d-169a-415c-bd4b-c59d919b8dda",
						"name": "考勤备案",
						"step_type": "submit",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 781,
						"posy": 359,
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
								"_id": "db7e8f1e-c22b-4632-83b7-13e343b8adf3",
								"name": "",
								"state": "submitted",
								"to_step": "F6C0ADBE-E24B-4A13-93FD-1BB6409A961B",
								"description": ""
							}
						],
						"approver_roles_name": []
					}
				]
			},
			"current_no": 1,
			"name_formula": "",
			"historys": []
		}
	]
}