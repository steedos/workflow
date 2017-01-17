workflowTemplate["en"].push {
	"_id": "0D92C954-4C61-48E3-BBAD-740F4C66F614",
	"app": "workflow",
	"approve_on_create": false,
	"approve_on_delete": false,
	"approve_on_modify": false,
	"created": "2013-11-11T02:01:26.319Z",
	"created_by": "519978e28e296a2fef000012",
	"current": {
		"_id": "1F56D65B-7B35-4C6E-851E-7EBCB021E0E0",
		"_rev": 1,
		"created": "2013-11-11T02:01:26.319Z",
		"created_by": "519978e28e296a2fef000012",
		"modified": "2013-11-11T02:06:03.887Z",
		"modified_by": "519978e28e296a2fef000012",
		"start_date": "2013-11-11T02:06:03.887Z",
		"form": "0D92C954-4C61-48E3-BBAD-740F4C66F614",
		"fields": [
			{
				"_id": "BB34731B-8164-4974-8554-92B4540739DB",
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
				"_id": "984B847C-FE9D-462F-A190-18F9F70582AD",
				"code": "Invoice details ",
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
						"_id": "FEB64AD9-B339-43AA-8AF2-90C924C06A05",
						"code": "Vendor Name",
						"is_required": true,
						"is_wide": true,
						"type": "input",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Vendor Name"
					},
					{
						"_id": "06AB0217-0C2D-4222-8FFF-32E1296B3EA5",
						"code": "Invoice Number",
						"is_required": false,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Invoice Number"
					},
					{
						"_id": "E6039BE0-619A-499B-901B-CAC527F2DBA0",
						"code": "Invoice Date",
						"is_required": false,
						"is_wide": false,
						"type": "date",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Date"
					},
					{
						"_id": "5D26A97F-5EDE-45AA-8382-ECA269992058",
						"code": "Invoice Amount",
						"is_required": true,
						"is_wide": false,
						"type": "number",
						"rows": 4,
						"digits": 2,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Invoice Amount"
					},
					{
						"_id": "D8818702-039E-4FC4-A65D-5EADB5EFEE96",
						"code": "Payment Mode",
						"default_value": "",
						"is_required": false,
						"is_wide": false,
						"type": "select",
						"rows": 4,
						"digits": 0,
						"options": "Cheque\nWire transfer",
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Payment Mode"
					},
					{
						"_id": "3A7B69E4-E6F6-4215-BFA5-0EC5DE2417D0",
						"code": "Pay Before",
						"is_required": false,
						"is_wide": false,
						"type": "date",
						"rows": 4,
						"digits": 0,
						"has_others": false,
						"is_multiselect": false,
						"oldCode": "Pay Before"
					}
				]
			}
		]
	},
	"is_deleted": false,
	"is_subform": false,
	"is_valid": true,
	"name": "Pay My Invoice",
	"space": "526785fb3349041651000a75",
	"state": "enabled",
	"historys": [],
	"flows": [
		{
			"_id": "60DFE1B0-232A-4420-8C62-5A79826671C1",
			"app": "workflow",
			"code_formula": "",
			"created": "2013-11-11T02:07:38.567Z",
			"created_by": "519978e28e296a2fef000012",
			"current": {
				"_id": "985da05a-3938-447f-bb23-d90274e5e751",
				"_rev": 2,
				"flow": "60DFE1B0-232A-4420-8C62-5A79826671C1",
				"form_version": "1F56D65B-7B35-4C6E-851E-7EBCB021E0E0",
				"modified": "2013-11-19T08:41:02.235Z",
				"modified_by": "519978e28e296a2fef000012",
				"created": "2013-11-19T08:40:56.356Z",
				"created_by": "519978e28e296a2fef000012",
				"start_date": "2013-11-19T08:41:02.235Z",
				"steps": [
					{
						"_id": "BF111A41-2123-4EF4-A281-74C4C9452585",
						"name": "Initiate Request",
						"step_type": "start",
						"deal_type": "",
						"description": "",
						"posx": 37.986114501953125,
						"posy": 182.49305725097656,
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
							"Invoice details ": "editable",
							"Vendor Name": "editable",
							"Invoice Number": "editable",
							"Invoice Date": "editable",
							"Invoice Amount": "editable",
							"Payment Mode": "editable",
							"Pay Before": "editable"
						},
						"lines": [
							{
								"_id": "9F93F3E4-7EF9-499D-B226-DB532F9AACCC",
								"name": "",
								"state": "submitted",
								"to_step": "d0eefab0-0b06-4612-a723-3b0773a49062",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "d0eefab0-0b06-4612-a723-3b0773a49062",
						"name": "Manager Approval",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 196.11111450195312,
						"posy": 184.61111450195312,
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
								"_id": "83b9a316-6866-40a4-b89b-8fff230f7490",
								"name": "",
								"state": "approved",
								"to_step": "ce70742a-845e-4a5a-8673-eeaee7262c20",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "ce70742a-845e-4a5a-8673-eeaee7262c20",
						"name": "Pay My Invoice",
						"step_type": "sign",
						"deal_type": "pickupAtRuntime",
						"description": "",
						"posx": 379.62847900390625,
						"posy": 186.1319580078125,
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
								"_id": "c5574a1a-74f4-4cc9-be5c-d8035430413b",
								"name": "",
								"state": "approved",
								"to_step": "99988F1C-491D-4EFB-AEC7-0A0BFE68C720",
								"description": ""
							}
						],
						"approver_roles_name": []
					},
					{
						"_id": "99988F1C-491D-4EFB-AEC7-0A0BFE68C720",
						"name": "Completed",
						"step_type": "end",
						"deal_type": "",
						"description": "",
						"posx": 549,
						"posy": 184.48959350585938,
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
			"current_no": 0,
			"description": "",
			"flowtype": "new",
			"form": "0D92C954-4C61-48E3-BBAD-740F4C66F614",
			"help_text": "",
			"is_deleted": false,
			"is_valid": true,
			"name": "Pay My Invoice",
			"name_formula": "",
			"space": "526785fb3349041651000a75",
			"state": "enabled",
			"historys": []
		}
	]
}