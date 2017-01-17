workflowTemplate["en"].push {
	"_id": "D2C2D5EE-9CF9-4386-841E-3CC18098E679",
	"app": "workflow",
	"approve_on_create": false,
	"approve_on_delete": false,
	"approve_on_modify": false,
	"created": "2013-11-08T10:39:37.095Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "0F65EC5E-E91F-4212-A993-53C5D39CF0D5",
		"_rev": 1,
		"created": "2013-11-08T10:39:37.095Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2013-11-08T10:54:37.981Z",
		"modified_by": "519978e28e296a2fef000012",
		"start_date": "2013-11-08T10:54:37.981Z",
		"finish_date": "2013-11-08T10:54:30.821Z",
		"form": "D2C2D5EE-9CF9-4386-841E-3CC18098E679",
		"fields": [
			{
				"_id": "2B564261-4309-45E2-9F21-6ECB55CCB3C3",
				"code": "Requestor Department",
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
				"_id": "122BD96C-E287-4497-ACA4-8DE7D8003E65",
				"code": "Email",
				"is_required": false,
				"is_wide": false,
				"type": "email",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": []
			},
			{
				"_id": "8252E86D-C1E7-40EF-BF07-6D43815424F4",
				"code": " Loan Details",
				"is_required": false,
				"is_wide": true,
				"type": "section",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": [
					{
						"_id": "F2823C57-8C1C-468E-B227-F74A02CC3F51",
						"code": "Purpose of Loan",
						"is_required": true,
						"is_wide": true,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Purpose of Loan"
					},
					{
						"_id": "6E6822C6-7DA4-490F-B8FB-209D084C5EEF",
						"code": "Loan Amount Required",
						"is_required": true,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 2,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Loan Amount Required"
					},
					{
						"_id": "3755DD40-A76D-4BEA-927B-317D21B4052F",
						"code": "Loan Recovery Option",
						"default_value": "",
						"is_required": false,
						"is_wide": false,
						"type": "select",
						"rows": 4,
						"digits": 0,
						"options": "Deduct form Salary\nOthers",
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Loan Recovery Option"
					},
					{
						"_id": "D2D4D725-3597-40B3-BD5E-C671F9FB29FB",
						"code": "If Others Specify",
						"is_required": false,
						"is_wide": false,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "If Others Specify"
					}
				]
			},
			{
				"_id": "856553B4-B27A-48B0-BE8E-5421F1B796FD",
				"code": "To be filled by Finance Team",
				"is_required": false,
				"is_wide": true,
				"type": "section",
				"rows": 4,
				"digits": 0,
				"has_others": false,
				"is_multiselect": false,
				"subform_fields": [],
				"fields": [
					{
						"_id": "4ED9B536-050C-4A72-8D59-EA5A68FDE72F",
						"code": "Approved Loan Amount",
						"is_required": false,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 2,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Approved Loan Amount"
					},
					{
						"_id": "2C3E4DC5-3D0D-47DF-8215-9B0C984B616D",
						"code": "Recovery Amount",
						"is_required": false,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 2,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Recovery Amount"
					},
					{
						"_id": "D7B08259-77A4-4D1D-A4BF-9D2AC9E9FE4D",
						"code": "Recovery Start Date",
						"is_required": false,
						"is_wide": false,
						"type": "date",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Recovery Start Date"
					},
					{
						"_id": "400D2CA6-209A-4F83-92B7-270E13AC501E",
						"code": "Recovery End Date\t",
						"is_required": false,
						"is_wide": false,
						"type": "date",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Recovery End Date\t"
					}
				]
			}
		]
	},
	"description": "Requestor Information",
	"is_deleted": false,
	"is_subform": false,
	"is_valid": true,
	"name": "Loan Request",
	"space": "526785fb3349041651000a75",
	"state": "enabled",
	"historys": [],
	"flows": [
		{
			"_id": "30B8A92B-FED9-44F5-AC17-6A187ABFE848",
			"name": "Loan Request",
			"code_formula": "",
			"space": "526785fb3349041651000a75",
			"description": "",
			"is_valid": true,
			"form": "D2C2D5EE-9CF9-4386-841E-3CC18098E679",
			"flowtype": "new",
			"state": "enabled",
			"created": "2013-11-08T10:51:26.919Z",
			"created_by": "519978e28e296a2fef000012",
			"help_text": "",
			"is_deleted": false,
			"app": "workflow",
			"current": {
				"_id": "98bbb877-5aaa-47fb-b541-d9699b5422fb",
				"_rev": 2,
				"flow": "30B8A92B-FED9-44F5-AC17-6A187ABFE848",
				"form_version": "0F65EC5E-E91F-4212-A993-53C5D39CF0D5",
				"modified": "2013-12-30T03:20:22.115Z",
				"modified_by": "519978e28e296a2fef000012",
				"created": "2013-11-19T08:40:25.609Z",
				"created_by": "519978e28e296a2fef000012",
				"start_date": "2013-11-19T08:40:33.435Z",
				"steps": [
					{
						"_id": "27ACA728-B775-4B75-A1F6-EF29FB563B6D",
						"name": "Initiate Request",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 40.75,
						"posy": 187,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"__form": "editable",
							"Email": "editable",
							" Loan Details": "editable",
							"Purpose of Loan": "editable",
							"Loan Amount Required": "editable",
							"Loan Recovery Option": "editable",
							"If Others Specify": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "2473D90A-C743-4071-BD3B-0CAB2BB808E4",
								"name": "",
								"state": "submitted",
								"to_step": "264446f9-2acc-439c-9e97-efd3b3025c03",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "264446f9-2acc-439c-9e97-efd3b3025c03",
						"name": "Manager Approval",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 199,
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
								"_id": "67ca9eb3-9688-401b-98d2-d4fcd176cf17",
								"name": "",
								"state": "approved",
								"to_step": "58e6f367-564c-497a-91c1-a3b82df96cb0",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "58e6f367-564c-497a-91c1-a3b82df96cb0",
						"name": "Finance Processing",
						"step_type": "submit",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 354,
						"posy": 190,
						"timeout_hours": 168,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {
							"To be filled by Finance Team": "editable",
							"Approved Loan Amount": "editable",
							"Recovery Amount": "editable",
							"Recovery Start Date": "editable",
							"Recovery End Date\t": "editable"
						},
						"fields_modifiable": [],
						"lines": [
							{
								"_id": "294b9445-2b7f-4899-9a9a-6ffa3292d5c0",
								"name": "",
								"state": "submitted",
								"to_step": "33D0CB10-45BF-44C8-B84F-A3E92E3A12FC",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "33D0CB10-45BF-44C8-B84F-A3E92E3A12FC",
						"name": "Completed",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 499.25,
						"posy": 193,
						"approver_user_field": "",
						"approver_org_field": "",
						"approver_roles": [],
						"approver_orgs": [],
						"approver_users": [],
						"approver_step": "",
						"permissions": {},
						"fields_modifiable": [],
						"approver_roles_name": []
					}
				]
			},
			"current_no": 4,
			"name_formula": "",
			"historys": []
		}
	]
}