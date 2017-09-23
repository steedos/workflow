# 采购申请
workflowTemplate["zh-CN"].push {
	"_id": "DA0B0046-D48D-4842-B548-8A46D5294529",
	"name": "采购申请",
	"state": "enabled",
	"is_deleted": false,
	"is_valid": true,
	"space": "526621803349041651000a1a",
	"created": "2014-02-27T08:47:27.548Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "46ad410c-fb83-473d-9b13-8c165190a57b",
		"_rev": 14,
		"created": "2015-11-19T08:38:59.372Z",
		"created_by": "521c5ab612efd2040700006d",
		"modified": "2015-11-19T08:38:59.457Z",
		"modified_by": "521c5ab612efd2040700006d",
		"start_date": "2015-11-19T08:38:59.372Z",
		"form": "DA0B0046-D48D-4842-B548-8A46D5294529",
		"fields": [
			{
				"_id": "AE3290F5-0DE7-4169-9247-F554D783D4E2",
				"code": "供应商名称",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "供应商名称",
				"subform_fields": []
			},
			{
				"_id": "64F63542-9B59-4C44-8BA7-03F011CB8172",
				"code": "联系人",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "联系人",
				"subform_fields": []
			},
			{
				"_id": "58061691-2968-4E6A-B5F2-715335372150",
				"code": "联系电话",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "联系电话",
				"subform_fields": []
			},
			{
				"_id": "8543F448-C845-47F3-9860-CD8D603D087C",
				"code": "采购原因",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "采购原因",
				"subform_fields": []
			},
			{
				"_id": "58A7585A-319B-4C75-8554-D940AD16967A",
				"code": "是否供应商",
				"default_value": "",
				"is_required": false,
				"is_wide": false,
				"type": "radio",
				"rows": 4,
				"digits": 0,
				"options": "是\n否",
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "是否供应商"
			},
			{
				"_id": "B29AE500-C56B-4AF9-A710-74FFFBDF0A0E",
				"code": "采购明细",
				"is_required": false,
				"is_wide": true,
				"type": "table",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "采购明细",
				"subform_fields": [],
				"fields": [
					{
						"_id": "6D501134-6A54-413E-B2D3-2316B0269E0B",
						"code": "采购类别",
						"default_value": "",
						"is_required": true,
						"is_wide": false,
						"type": "select",
						"rows": 4,
						"digits": 0,
						"options": "办公用品采购\n固定资产采购\n原材料采购\n成品外购\n车间耗材\n货物采购\n标签外加工\n辅料\n加工",
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "采购类别"
					},
					{
						"_id": "F94E435B-96E4-408D-8E97-66505D5F69D9",
						"code": "产品名称",
						"is_required": true,
						"is_wide": false,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "产品名称"
					},
					{
						"_id": "3B4222CF-AB78-41B1-84D8-4525B04B4A9B",
						"code": "数量",
						"is_required": true,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "数量"
					},
					{
						"_id": "A7D9ECD1-365F-4BE0-9561-53BE317B41E3",
						"code": "单价",
						"is_required": true,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 2,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "单价"
					},
					{
						"_id": "42EBEAC2-F823-4009-A9DA-CF6B7CD06F9F",
						"code": "总价",
						"is_required": false,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 2,
						"formula": "{单价}*{数量}",
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "总价"
					}
				]
			},
			{
				"_id": "45FFB5E1-498D-4135-B06D-C7A56386763A",
				"code": "采购金额合计",
				"is_required": false,
				"is_wide": true,
				"type": "number",
				"rows": 4,
				"digits": 2,
				"formula": "sum({总价})",
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "采购金额合计",
				"subform_fields": []
			},
			{
				"_id": "C4793753-8AF1-42DD-B044-D4B0247B2DBE",
				"code": "合同签订日期",
				"is_required": true,
				"is_wide": false,
				"type": "date",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false
			},
			{
				"_id": "8F42691D-1D76-4C90-B65C-2A10B16C7F3B",
				"code": "合同名称",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false
			},
			{
				"_id": "76749E90-9F3C-4D28-87D6-40A869D4BEC6",
				"code": "开户行",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false
			},
			{
				"_id": "EEF6CE84-9128-498F-80D0-0164C8831387",
				"code": "账号",
				"is_required": true,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "账号"
			},
			{
				"_id": "5F99D36A-5BDA-41E1-877B-279B28F74F73",
				"code": "备注",
				"is_required": false,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "备注",
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
			"_id": "A9EF445E-5C9E-40E7-9CC0-81E02EA9B822",
			"name": "采购申请",
			"code_formula": "",
			"space": "526621803349041651000a1a",
			"description": "",
			"is_valid": true,
			"form": "DA0B0046-D48D-4842-B548-8A46D5294529",
			"flowtype": "new",
			"state": "enabled",
			"created": "2014-02-27T08:57:21.907Z",
			"created_by": "519978e28e296a2fef000012",
			"help_text": "",
			"is_deleted": false,
			"app": "workflow",
			"current": {
				"_id": "c7cfe864-36eb-4a04-9fb5-5675e98a940d",
				"_rev": 19,
				"flow": "A9EF445E-5C9E-40E7-9CC0-81E02EA9B822",
				"form_version": "46ad410c-fb83-473d-9b13-8c165190a57b",
				"modified": "2015-11-19T08:38:59.372Z",
				"modified_by": "521c5ab612efd2040700006d",
				"created": "2015-11-19T08:38:33.611Z",
				"created_by": "521c5ab612efd2040700006d",
				"start_date": "2015-11-19T08:38:33.611Z",
				"steps": [
					{
						"_id": "CB20B92D-1D61-4347-868F-A301A89006DB",
						"name": "开始填写",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 59,
						"posy": 124,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"__form": "editable",
							"供应商名称": "editable",
							"联系人": "editable",
							"联系电话": "editable",
							"采购原因": "editable",
							"采购明细": "editable",
							"采购类别": "editable",
							"产品名称": "editable",
							"数量": "editable",
							"单价": "editable",
							"日期-时间": "editable",
							"日期": "editable",
							"文本": "editable",
							"文本1": "editable",
							"选择用户": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "1341b6d9-d7fb-4e34-8675-86ec9ee51644",
								"name": "",
								"state": "submitted",
								"to_step": "65e651c3-332d-4ad7-9213-b640657cec7a",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "2A06D8EF-92DE-4B09-BFF6-AACCC2C7C34B",
						"name": "结束",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 821,
						"posy": 377,
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
						"_id": "65e651c3-332d-4ad7-9213-b640657cec7a",
						"name": "部门经理审批合同",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 172,
						"posy": 125,
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
								"_id": "43302b48-852c-42b5-8498-7bb5c5c08c54",
								"name": "",
								"state": "approved",
								"to_step": "f227c336-d0b7-4da1-aec0-3350243d92ae",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "f227c336-d0b7-4da1-aec0-3350243d92ae",
						"name": "采购总金额是否大于\n5000元？",
						"step_type": "condition",
						"deal_type": "",
						"description": "",
						"posx": 326,
						"posy": 115,
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
								"_id": "3a565ad5-dbd7-45ac-8d6c-450adabb23cb",
								"name": ">=5000元",
								"state": "submitted",
								"condition": "{采购金额合计}>=5000",
								"to_step": "d92b970e-2609-41bf-82f0-1b630fc90822",
								"description": ""
							},
							{
								"_id": "c63160f0-39ee-4db7-af6d-d8e212e2c6c9",
								"name": "<5000元",
								"state": "submitted",
								"condition": "{采购金额合计}<5000",
								"to_step": "fa2bcba5-2ad1-4a4b-9b50-7a5d728c01d0",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "d92b970e-2609-41bf-82f0-1b630fc90822",
						"name": "总经理审批合同",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 557,
						"posy": 16,
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
								"_id": "94902f2f-77f4-468b-865f-f79e057a1668",
								"name": "",
								"state": "approved",
								"to_step": "fa2bcba5-2ad1-4a4b-9b50-7a5d728c01d0",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "fa2bcba5-2ad1-4a4b-9b50-7a5d728c01d0",
						"name": "申请人合同盖章申请",
						"step_type": "sign",
						"deal_type": "applicant",
						"description": "",
						"posx": 543,
						"posy": 123,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"合同明细": "editable",
							"合同签订日期": "editable",
							"合同名称": "editable",
							"开户行": "editable",
							"账号": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "3edb3531-1629-4ccf-9b89-0aa7f47668ff",
								"name": "",
								"state": "approved",
								"to_step": "e77eeff1-2b82-422d-9397-ba3559da3daf",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "e77eeff1-2b82-422d-9397-ba3559da3daf",
						"name": "部门经理盖章审核",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 743,
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
								"_id": "bce093e3-ebea-49a3-b6db-342a3ce61be4",
								"name": "",
								"state": "approved",
								"to_step": "1d7b5aba-5229-4e9f-9a3d-24bc348736c7",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "1d7b5aba-5229-4e9f-9a3d-24bc348736c7",
						"name": "申请人付款申请",
						"step_type": "sign",
						"deal_type": "applicant",
						"description": "",
						"posx": 560,
						"posy": 234,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"付款金额": "editable",
							"备注": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "6be8c0b9-e7d2-4059-b9bf-476ebe2bd8ef",
								"name": "",
								"state": "approved",
								"to_step": "005661fe-8155-46c5-a9a5-a1a2bd8ac790",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "005661fe-8155-46c5-a9a5-a1a2bd8ac790",
						"name": "部门经理审核\n付款申请",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 439,
						"posy": 294,
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
								"_id": "9ed17682-195f-4b2d-9f19-38dbeb01048c",
								"name": "",
								"state": "approved",
								"to_step": "5b7ee2d4-c25e-4c43-8386-9735e28a8f53",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "5b7ee2d4-c25e-4c43-8386-9735e28a8f53",
						"name": "财务部付款审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 302,
						"posy": 380,
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
								"_id": "5b755d9e-3e8d-4ac4-b757-11c30d9ef713",
								"name": "",
								"state": "approved",
								"to_step": "66fd85cc-bcf8-43e5-acd7-4be28a4b1406",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "66fd85cc-bcf8-43e5-acd7-4be28a4b1406",
						"name": "总经理付款审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 503,
						"posy": 379,
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
								"_id": "ee9cfbbd-999b-4150-b294-13e8ed511739",
								"name": "",
								"state": "approved",
								"to_step": "5e93c6df-f369-4b3d-88d4-8ad5b6440443",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "5e93c6df-f369-4b3d-88d4-8ad5b6440443",
						"name": "出纳付货款",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 673,
						"posy": 379,
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
								"_id": "c5fe9528-e946-485e-9e6f-eb4e67b44649",
								"name": "",
								"state": "approved",
								"to_step": "2A06D8EF-92DE-4B09-BFF6-AACCC2C7C34B",
								"description": ""
							}
						],
						"approver_roles_name": []
					}
				]
			},
			"current_no": 9,
			"name_formula": "",
			"historys": []
		}
	]
}