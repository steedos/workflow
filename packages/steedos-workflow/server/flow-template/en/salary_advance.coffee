workflowTemplate["en"].push {
	"_id": "7893D038-D2C5-4B98-860F-BD3EDB385A62",
	"app": "workflow",
	"approve_on_create": false,
	"approve_on_delete": false,
	"approve_on_modify": false,
	"created": "2013-11-11T01:38:49.921Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "3B93660E-2083-4341-A2C9-0FB08FE1B8FB",
		"_rev": 1,
		"created": "2013-11-11T01:38:49.921Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2013-11-11T01:41:28.165Z",
		"modified_by": "519978e28e296a2fef000012",
		"start_date": "2013-11-11T01:41:28.165Z",
		"form": "7893D038-D2C5-4B98-860F-BD3EDB385A62",
		"fields": [
			{
				"_id": "C8A43338-D1E8-4FE7-9394-6372A1F2C871",
				"code": "Employee ID",
				"is_required": false,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "0E1D89E7-4D61-44CC-8943-EDB877144CA3",
				"code": "Department Name",
				"is_required": false,
				"is_wide": false,
				"type": "input",
				"rows": 4,
				"digits": 0,
				"formula": "{applicant.organization.fullname}",
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "21E67B2D-0566-46BC-B720-3918BAE7C213",
				"code": "Salary Advance Amount",
				"is_required": true,
				"is_wide": false,
				"type": "number",
				"rows": 4,
				"digits": 2,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "5B0579AA-D723-4225-969E-BCF652D837CD",
				"code": "Reason for Advance",
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
	"is_deleted": false,
	"is_subform": false,
	"is_valid": true,
	"name": "Salary Advance",
	"space": "526785fb3349041651000a75",
	"state": "enabled",
	"historys": [],
	"flows": [
		{
			"_id": "ED54AF1A-E342-4C22-8BC4-F9AADB30E88A",
			"app": "workflow",
			"code_formula": "",
			"created": "2013-11-11T01:41:42.904Z",
			"created_by": "519978e28e296a2fef000012",
			"current": {
				"_id": "98f541a3-2357-4c0b-8967-5e9871dea137",
				"_rev": 6,
				"flow": "ED54AF1A-E342-4C22-8BC4-F9AADB30E88A",
				"form_version": "3B93660E-2083-4341-A2C9-0FB08FE1B8FB",
				"modified": "2013-11-27T06:44:47.334Z",
				"modified_by": "519978e28e296a2fef000012",
				"created": "2013-11-27T06:44:43.565Z",
				"created_by": "519978e28e296a2fef000012",
				"start_date": "2013-11-27T06:44:47.334Z",
				"steps": [
					{
						"_id": "8FD4F877-D395-42B5-A572-F3B7F5881242",
						"name": "Initiate Request",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 46.986114501953125,
						"posy": 195.49305725097656,
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
							"Employee ID": "editable",
							"Salary Advance Amount": "editable",
							"Reason for Advance": "editable"
						},
						"lines": [
							{
								"_id": "7BAB770F-30A4-4376-A4F0-EAD03A1AE58B",
								"name": "",
								"state": "submitted",
								"to_step": "bb0815dc-bca2-4e15-8797-4fa6c69d7e77",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "bb0815dc-bca2-4e15-8797-4fa6c69d7e77",
						"name": "Manager Approval",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 210.107666015625,
						"posy": 195.61805725097656,
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
								"_id": "ef0c9c32-aecb-42c7-9de0-67c73016cd19",
								"name": "",
								"state": "approved",
								"to_step": "f89201be-1ab2-41ea-95df-d5b41ec4033d",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "9053241e-1c42-4be0-99e3-0e09e69ebb27",
						"name": "Pending for Closure",
						"step_type": "submit",
						"deal_type": "applicant",
						"description": "",
						"posx": 354.62847900390625,
						"posy": 324.1041717529297,
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
								"_id": "6f81982f-69c4-4155-ad2e-5196d8f01fbf",
								"name": "",
								"state": "submitted",
								"to_step": "6DDB6123-4E74-41ED-A8FE-0745E7F6A186",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "f89201be-1ab2-41ea-95df-d5b41ec4033d",
						"name": "Finance Approval",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 363.1145935058594,
						"posy": 194.6041717529297,
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
								"_id": "88f0b6dd-eec6-40c0-b21c-e9fe4754b47c",
								"name": "",
								"state": "approved",
								"to_step": "9053241e-1c42-4be0-99e3-0e09e69ebb27",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "6DDB6123-4E74-41ED-A8FE-0745E7F6A186",
						"name": "Completed",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 559.99658203125,
						"posy": 323.49305725097656,
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
			"current_no": 1,
			"description": "",
			"flowtype": "new",
			"form": "7893D038-D2C5-4B98-860F-BD3EDB385A62",
			"help_text": "",
			"is_deleted": false,
			"is_valid": true,
			"name": "Salary Advance",
			"name_formula": "",
			"space": "526785fb3349041651000a75",
			"state": "enabled",
			"historys": []
		}
	]
}