
# 日常费用报销
workflowTemplate["zh-CN"].push {
	"_id": "1D8CDCA5-9D6B-4D9C-960D-AE109051EDB9",
	"name": "日常费用报销",
	"state": "enabled",
	"is_deleted": false,
	"is_valid": true,
	"space": "526621803349041651000a1a",
	"created": "2013-11-08T10:05:32.728Z",
	"created_by": "51a454038e296a1c3b000002",
	"current": {
		"_id": "c84f454d-88f1-4901-af5e-39a3403bed24",
		"_rev": 5,
		"created": "2014-03-04T08:37:18.073Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2016-01-06T05:39:04.641Z",
		"modified_by": "521c5ab612efd2040700006d",
		"start_date": "2016-01-06T05:39:04.641Z",
		"finish_date": "2015-08-11T02:30:56.308Z",
		"form": "1D8CDCA5-9D6B-4D9C-960D-AE109051EDB9",
		"fields": [
			{
				"_id": "877D96AE-FADC-4305-9542-B34B61E5EB60",
				"code": "报销明细",
				"description": "注：如果用其他发票代替报销的，请选择实际用途。例：购买办公用品由于没有发票，用车票代替，那么在费用类别里应该选择办公用品。",
				"is_required": false,
				"is_wide": true,
				"type": "table",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "报销明细",
				"subform_fields": [],
				"fields": [
					{
						"_id": "5B32FAB2-B69A-447A-BF46-E88C6B8077F8",
						"code": "费用类别",
						"default_value": "",
						"is_required": true,
						"is_wide": false,
						"type": "select",
						"rows": 4,
						"digits": 0,
						"options": "市内交通费\n餐费\n办公用品\n食品\n礼品\n其他",
						"has_others": false,
						"is_multiselect": false
					},
					{
						"_id": "2E28D4EA-A0CD-4070-86C2-D266FE3A35C4",
						"code": "报销金额",
						"is_required": true,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 2,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "报销金额"
					},
					{
						"_id": "CB879DFB-3D95-4FBC-9120-8038D65EA911",
						"code": "费用产生日期",
						"is_required": true,
						"is_wide": false,
						"type": "date",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "费用产生日期"
					},
					{
						"_id": "1D508236-DAE6-4860-97AA-57823DF0CF9C",
						"code": "备注",
						"is_required": false,
						"is_wide": false,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "备注"
					}
				]
			},
			{
				"_id": "974D2FF8-F80E-4676-BABA-D31EEDE5E747",
				"code": "报销金额合计",
				"is_required": false,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 2,
				"formula": "sum({报销金额})",
				"has_others": false,
				"is_multiselect": false,
				"oldCode": "报销金额合计",
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
			"_id": "EEA7D9BD-7E81-4CBE-BC08-A9A0AE4FD0C5",
			"name": "日常费用报销",
			"name_formula": "",
			"code_formula": "",
			"space": "526621803349041651000a1a",
			"description": "",
			"is_valid": true,
			"form": "1D8CDCA5-9D6B-4D9C-960D-AE109051EDB9",
			"flowtype": "new",
			"state": "enabled",
			"is_deleted": false,
			"created": "2013-11-08T10:13:50.866Z",
			"created_by": "51a454038e296a1c3b000002",
			"help_text": "",
			"current_no": 6,
			"current": {
				"_id": "2857ce50-386d-4134-b52e-7a7ce0db5d02",
				"_rev": 10,
				"flow": "EEA7D9BD-7E81-4CBE-BC08-A9A0AE4FD0C5",
				"form_version": "c84f454d-88f1-4901-af5e-39a3403bed24",
				"modified": "2016-05-24T09:23:03.384Z",
				"modified_by": "521c5ab612efd2040700006d",
				"created": "2016-05-24T09:23:03.384Z",
				"created_by": "521c5ab612efd2040700006d",
				"start_date": "2016-05-24T09:23:03.384Z",
				"steps": [
					{
						"_id": "73780A0A-572B-45B2-B386-FAC84A7F55B1",
						"name": "开始填写",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 89.9930572509766,
						"posy": 59.9965286254883,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"fields_modifiable": [],
						"permissions": {
							"__form": "editable",
							"费用类别": "editable",
							"报销金额": "editable",
							"费用产生日期": "editable",
							"备注": "editable",
							"报销明细": "editable"
						},
						"lines": [
							{
								"_id": "658295E6-C74F-48B2-9952-6F891A9D678E",
								"name": "",
								"state": "submitted",
								"to_step": "5d70534c-a383-4bb4-abb1-2be29ba6f12d",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "5d70534c-a383-4bb4-abb1-2be29ba6f12d",
						"name": "部门经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 241.986129760742,
						"posy": 58.9861145019531,
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
								"_id": "fa3eb63a-328e-4d70-a346-85720a35ca57",
								"name": "",
								"state": "approved",
								"to_step": "f76f9249-3439-407d-a39f-e25e37d79d78",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "f76f9249-3439-407d-a39f-e25e37d79d78",
						"name": "总经理审批",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 245.986145019531,
						"posy": 181.996528625488,
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
								"_id": "eecdd2bb-b0cb-4e5a-a6b6-ed0344969255",
								"name": "",
								"state": "approved",
								"to_step": "d7e58f60-ad90-45cf-bfac-1b159d11e06c",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "1bc9a350-fe0c-4716-ac98-ad85df512b9e",
						"name": "发放报销款",
						"step_type": "submit",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 248.982650756836,
						"posy": 425.003494262695,
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
								"_id": "e52b066e-f732-4624-8452-a64e05a86824",
								"name": "",
								"state": "submitted",
								"to_step": "86c71e13-8e36-4bbc-ac3b-dd024649cd45",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "ce60d7a9-da73-4ca9-bd9b-a6da0b5cdef2",
						"name": "财务部审核",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 249.989593505859,
						"posy": 307.986129760742,
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
								"_id": "d0be317b-2987-4370-ac28-e59f551c62ec",
								"name": "",
								"state": "approved",
								"to_step": "1bc9a350-fe0c-4716-ac98-ad85df512b9e",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "BF860B96-3515-4051-9F03-57F23D840016",
						"name": "结束",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 258.954864501953,
						"posy": 568.972274780273,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"fields_modifiable": [],
						"permissions": {},
						"approver_roles_name": []
					},
					{
						"_id": "d7e58f60-ad90-45cf-bfac-1b159d11e06c",
						"name": "报销人提交纸质报销单至财务部",
						"step_type": "submit",
						"deal_type": "applicant",
						"description": "",
						"posx": 398,
						"posy": 171,
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
								"_id": "1825eccf-90d7-47b9-a58c-4ee8155e5c78",
								"name": "",
								"state": "submitted",
								"to_step": "ce60d7a9-da73-4ca9-bd9b-a6da0b5cdef2",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "86c71e13-8e36-4bbc-ac3b-dd024649cd45",
						"name": "确认收款",
						"step_type": "sign",
						"deal_type": "applicant",
						"description": "",
						"posx": 439,
						"posy": 422,
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
								"_id": "09c57ed0-4dd1-415e-a8ab-31fe50b95d67",
								"name": "",
								"state": "approved",
								"to_step": "BF860B96-3515-4051-9F03-57F23D840016",
								"description": ""
							}
						],
						"approver_roles_name": []
					}
				]
			},
			"app": "workflow",
			"historys": []
		}
	]
}