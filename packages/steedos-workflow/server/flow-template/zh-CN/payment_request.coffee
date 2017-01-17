
# 付款申请
workflowTemplate["zh-CN"].push {
	"_id": "C6A3B49F-E048-40E2-872D-E488ECE28B36",
	"name": "付款申请",
	"state": "enabled",
	"is_deleted": false,
	"is_valid": true,
	"space": "526621803349041651000a1a",
	"created": "2014-02-27T01:31:09.651Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "fe52c32c-4023-43f7-9609-ffaed53daef7",
		"_rev": 3,
		"created": "2014-03-04T08:34:39.162Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2015-10-29T06:49:31.744Z",
		"modified_by": "521c5ab612efd2040700006d",
		"start_date": "2014-03-04T08:34:43.185Z",
		"form": "C6A3B49F-E048-40E2-872D-E488ECE28B36",
		"fields": [
			{
				"_id": "6F0BCD4E-AF66-455C-8472-54A5890D2655",
				"code": "发票类型",
				"default_value": "",
				"is_required": true,
				"is_wide": false,
				"type": "select",
				"rows": 4,
				"digits": 0,
				"options": "增税专用发票\n增税普通发票\n普通机打发票\n收款收据",
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "发票类型"
			},
			{
				"_id": "DFC90A0D-5B3C-4423-8BA3-D8DCB1584D6E",
				"code": "产品名称",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "产品名称"
			},
			{
				"_id": "4F60856E-F3A9-4B11-972D-6FC10B25FBAF",
				"code": "付款金额",
				"is_required": true,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 2,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "付款金额"
			},
			{
				"_id": "B1E6254B-2505-4C8D-B869-CED86190226A",
				"code": "收款单位",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "收款单位"
			},
			{
				"_id": "487571EE-59AC-4E33-A79B-053075F3F1C3",
				"code": "开户行",
				"is_required": false,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "开户行"
			},
			{
				"_id": "27AD0F37-0AC5-4BF4-8DF9-30835A6E773A",
				"code": "账号",
				"is_required": false,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"oldCode": "账号"
			},
			{
				"_id": "A475B20B-1937-4CAF-A240-123063BAF260",
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
			"_id": "41C6B157-3F52-43B2-AC43-60B065A703C3",
			"name": "付款申请",
			"code_formula": "",
			"space": "526621803349041651000a1a",
			"description": "",
			"is_valid": true,
			"form": "C6A3B49F-E048-40E2-872D-E488ECE28B36",
			"flowtype": "new",
			"state": "enabled",
			"created": "2014-02-27T01:48:34.504Z",
			"created_by": "519978e28e296a2fef000012",
			"help_text": "",
			"is_deleted": false,
			"app": "workflow",
			"current": {
				"_id": "54d1c00c-c2da-4bfc-bdf5-e7928159ddf7",
				"_rev": 3,
				"flow": "41C6B157-3F52-43B2-AC43-60B065A703C3",
				"form_version": "fe52c32c-4023-43f7-9609-ffaed53daef7",
				"modified": "2014-03-04T08:34:47.150Z",
				"modified_by": "519978e28e296a2fef000012",
				"created": "2014-03-04T08:34:39.161Z",
				"created_by": "519978e28e296a2fef000012",
				"start_date": "2014-03-04T08:34:47.150Z",
				"steps": [
					{
						"_id": "58E36F35-CD08-453B-92DF-BF7384A8C3DF",
						"name": "开始填写",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 121.75,
						"posy": 123,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"__form": "editable",
							"发票类型": "editable",
							"产品名称": "editable",
							"付款金额": "editable",
							"收款单位": "editable",
							"开户行": "editable",
							"帐号": "editable",
							"备注情况": "editable",
							"账号": "editable",
							"备注": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "DB430857-6EBA-4828-BBC6-A999928BF034",
								"name": "",
								"state": "submitted",
								"to_step": "1865c925-4598-4704-bd56-3f4d1fa5d6ce",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "BF87E9FA-A47A-4E6C-9EED-3D36653BDB2E",
						"name": "结束",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 699.25,
						"posy": 429,
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
						"_id": "1865c925-4598-4704-bd56-3f4d1fa5d6ce",
						"name": "部门经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 298,
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
								"_id": "35a00fbf-685d-464b-ae8a-96db8f2e1db9",
								"name": "",
								"state": "approved",
								"to_step": "0719b980-3432-4284-967d-be8310ace2f3",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "0719b980-3432-4284-967d-be8310ace2f3",
						"name": "财务审核单据",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 478.80000000000007,
						"posy": 126,
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
								"_id": "ba6684ae-dd6a-450e-b3c4-b672449c29ba",
								"name": "",
								"state": "approved",
								"to_step": "4e96428d-bef6-42c8-a1ee-bd6496e71fd8",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "4e96428d-bef6-42c8-a1ee-bd6496e71fd8",
						"name": "总经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 485,
						"posy": 280,
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
								"_id": "27913ecf-71f5-4ae9-ac92-b9637b8dfbb6",
								"name": "",
								"state": "approved",
								"to_step": "2dad4be3-d487-4ea0-8d91-35e189d550b7",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "2dad4be3-d487-4ea0-8d91-35e189d550b7",
						"name": "出纳支出相关款项",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 465,
						"posy": 428,
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
								"_id": "99c34047-247f-41d1-8994-612c0699b69f",
								"name": "",
								"state": "approved",
								"to_step": "BF87E9FA-A47A-4E6C-9EED-3D36653BDB2E",
								"description": ""
							}
						],
						"approver_roles_name": []
					}
				]
			},
			"current_no": 10,
			"name_formula": "",
			"historys": []
		}
	]
}