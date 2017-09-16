#采购合同

workflowTemplate["zh-CN"].push {
  "_id": "310cbca588b9743f2e5a9f65",
  "name": "采购合同",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "created": "2017-09-14T02:27:56.214Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "820a6ac7-48e6-4d06-bf35-558421c55a5d",
    "_rev": 5,
    "created": "2017-09-15T06:04:16.793Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-15T06:04:16.833Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-15T06:04:16.793Z",
    "form": "310cbca588b9743f2e5a9f65",
    "form_script": "CoreForm.pageTitle= \"采购合同\";",
    "name_forumla": "",
    "fields": [
      {
        "_id": "C82502B0-C317-4741-A6FD-56E356850503",
        "code": "合同信息",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "合同信息",
        "fields": [
          {
            "_id": "ED39DDBC-CE4B-43BD-B98D-ED46040B6E91",
            "code": "合同名称",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "合同名称"
          },
          {
            "_id": "2B1E71AF-48E5-44EF-BD31-4420EB83E823",
            "code": "合同编号",
            "default_value": "auto_number(采购合同)",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "合同编号"
          },
          {
            "_id": "D49E1438-EB37-4C02-90F9-AC4F8024EA10",
            "code": "经办人员",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{applicant.name}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "经办人员"
          },
          {
            "_id": "3117A57B-E556-40DB-8CCD-F64D1648D9BA",
            "code": "经办部门",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{applicant.organization.name}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "经办部门"
          },
          {
            "_id": "1C4DD768-F6E0-43A2-AD24-79269FDFDF03",
            "code": "对方单位",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "对方单位"
          },
          {
            "_id": "A718224E-7740-4C8D-805E-5F738C595FD8",
            "code": "是否招标",
            "default_value": "",
            "is_required": false,
            "is_wide": false,
            "type": "select",
            "rows": 4,
            "digits": 0,
            "options": "否\n是",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "是否招标"
          },
          {
            "_id": "C63FD427-F276-4306-9654-EA822FED1496",
            "code": "合同金额",
            "is_required": false,
            "is_wide": false,
            "type": "number",
            "rows": 4,
            "digits": 2,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "合同金额"
          },
          {
            "_id": "B2F4AD3E-6EBE-4B8F-8A2E-22E5B3272EA1",
            "code": "是否申请付款",
            "default_value": "",
            "is_required": false,
            "is_wide": false,
            "type": "select",
            "rows": 4,
            "digits": 0,
            "options": "是\n否",
            "has_others": false,
            "is_multiselect": false
          },
          {
            "_id": "91A1187D-3CCD-46D2-85E9-BEBCB520B7AD",
            "code": "币种",
            "default_value": "人民币",
            "is_required": false,
            "is_wide": false,
            "type": "select",
            "rows": 4,
            "digits": 0,
            "options": "人民币\n港币\n美元",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "币种"
          },
          {
            "_id": "EA24A1F7-A9B1-4C65-8A66-14DA181B1752",
            "code": "备注",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "备注",
            "is_textarea": true
          }
        ]
      },
      {
        "_id": "C0BBDC66-4A37-4CE2-8C83-2E2F253D51DC",
        "code": "审批意见",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "审批意见",
        "fields": [
          {
            "_id": "F6761B86-4A66-4EBD-A03E-8C38D5D47A40",
            "code": "部门领导意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'部门领导审核'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "部门领导意见",
            "is_textarea": true
          },
          {
            "_id": "F98A51D0-BA61-4C11-AE4B-62A57445665C",
            "code": "办公室主任意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'办公室主任审核'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "办公室主任意见",
            "is_textarea": true
          },
          {
            "_id": "03470EF0-B121-4D9B-93BB-C2005606BF40",
            "code": "相关部门会签意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'相关部门会签'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "相关部门会签意见",
            "is_textarea": true
          },
          {
            "_id": "A07859AE-7ACB-49CA-A483-553AD58BCF95",
            "code": "法务意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'法务审核'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "法务意见",
            "is_textarea": true
          },
          {
            "_id": "EB7F75E8-6E71-4B86-8639-473216C50189",
            "code": "总经理意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'总经理审批'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "总经理意见",
            "is_textarea": true
          }
        ]
      }
    ]
  },
  "enable_workflow": false,
  "enable_view_others": false,
  "app": "workflow",
  "category": "59b9f331527eca4fc200001e",
  "instance_style": "table",
  "is_subform": false,
  "import": true,
  "historys": [],
  "category_name": "基本流程模板",
  "flows": [
    {
      "_id": "4ceb60f112ffda7b3cab45ec",
      "name": "采购合同",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "is_valid": true,
      "form": "310cbca588b9743f2e5a9f65",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-14T02:27:56.286Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current_no": 3,
      "current": {
        "_id": "ec0178e3-4194-4772-9362-5316763eb7b1",
        "_rev": 3,
        "flow": "4ceb60f112ffda7b3cab45ec",
        "form_version": "820a6ac7-48e6-4d06-bf35-558421c55a5d",
        "modified": "2017-09-15T06:04:17.159Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-15T06:04:16.793Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-15T06:04:16.793Z",
        "steps": [
          {
            "_id": "232350f9-94d4-4961-8cd2-0e034e2e2369",
            "name": "提交申请",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 28,
            "posy": 366.5,
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
              "合同名称": "editable",
              "对方单位": "editable",
              "是否招标": "editable",
              "合同金额": "editable",
              "合同编号": "editable",
              "文本1": "editable",
              "合同信息": "editable",
              "文本2": "editable",
              "下拉框1": "editable",
              "备注": "editable",
              "审批意见": "editable",
              "币种": "editable",
              "是否申请付款": "editable"
            },
            "can_edit_main_attach": true,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "228ea7fb-341a-45f7-9e99-c38ec48fbca9",
                "name": "",
                "state": "submitted",
                "to_step": "377d8917-0f22-4aa8-a99a-cc21490f106c",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "598c82fc-da94-4b91-823c-4203b6a25bde",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 987.75,
            "posy": 367.5,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "distribute_optional_flows": [],
            "approver_roles_name": []
          },
          {
            "_id": "377d8917-0f22-4aa8-a99a-cc21490f106c",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 194,
            "posy": 367,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "4GzKuzw4ke3BWscN8"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "3e18f0fd-529a-40c8-88e2-1ab403c0e240",
                "name": "",
                "state": "approved",
                "to_step": "10a1a7f6-4ce8-4a0d-a6c7-8bbf31bdb116",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "a43d26e0-bbac-4cad-ad2d-4c2ef959a4ed",
            "name": "法务审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 393,
            "posy": 194,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "gSqDxmG9DRA7oW9vR"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "78283118-08fa-456f-9184-2208680bdd87",
                "name": "",
                "state": "approved",
                "to_step": "10a1a7f6-4ce8-4a0d-a6c7-8bbf31bdb116",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "法律干事"
            ]
          },
          {
            "_id": "10a1a7f6-4ce8-4a0d-a6c7-8bbf31bdb116",
            "name": "办公室主任审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 374,
            "posy": 367,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "fM2c7opzHmqyWj4r3"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "2236322b-544c-4700-b456-8c93de9558bf",
                "name": "",
                "state": "approved",
                "to_step": "779d4c70-8843-43fe-9f6f-f52d21b66a18",
                "description": ""
              },
              {
                "_id": "ff493cc7-0157-4f5a-8644-8c0035d64b24",
                "name": "",
                "state": "approved",
                "to_step": "e4e4eaf7-95f5-47f4-827e-3b7d59159555",
                "description": ""
              },
              {
                "_id": "e73ceb76-0423-4d81-b139-169b14d44908",
                "name": "",
                "state": "approved",
                "to_step": "d99ad98d-3188-48c8-835b-1af689109de6",
                "description": ""
              },
              {
                "_id": "4b44f9ed-3220-4da8-b879-ed9fa421e5eb",
                "name": "",
                "state": "approved",
                "to_step": "a43d26e0-bbac-4cad-ad2d-4c2ef959a4ed",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "办公室主任"
            ]
          },
          {
            "_id": "d99ad98d-3188-48c8-835b-1af689109de6",
            "name": "相关部门会签",
            "step_type": "counterSign",
            "deal_type": "pickupAtRuntime",
            "description": "",
            "posx": 381,
            "posy": 534,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "7adaa193-1c7d-4fde-8a39-6aafcc936d18",
                "name": "",
                "state": "submitted",
                "to_step": "10a1a7f6-4ce8-4a0d-a6c7-8bbf31bdb116",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "779d4c70-8843-43fe-9f6f-f52d21b66a18",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 605,
            "posy": 367,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "51af1b2f8e296a29c9000063"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "60291d31-4cc9-49da-b9c6-88e5bc53e6f3",
                "name": "",
                "state": "approved",
                "to_step": "963e3b7e-6ee4-47e1-9e24-d60c4c7e66d5",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "963e3b7e-6ee4-47e1-9e24-d60c4c7e66d5",
            "name": "审批成功",
            "step_type": "submit",
            "deal_type": "applicant",
            "description": "",
            "posx": 802,
            "posy": 368,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "73c699fc-9a62-4ad6-9c4a-bb1b434419ba",
                "name": "",
                "state": "submitted",
                "to_step": "598c82fc-da94-4b91-823c-4203b6a25bde",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "e4e4eaf7-95f5-47f4-827e-3b7d59159555",
            "name": "相关领导会签",
            "step_type": "counterSign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 605,
            "posy": 537,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "cwFcwh6wwEEEXxqid"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "d33004a8-afb7-487d-9c1c-2009c47c0121",
                "name": "",
                "state": "submitted",
                "to_step": "10a1a7f6-4ce8-4a0d-a6c7-8bbf31bdb116",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "公司领导"
            ]
          }
        ]
      },
      "app": "workflow",
      "distribute_optional_users": [],
      "historys": []
    }
  ]
}
