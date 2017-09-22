#一周工作报告

workflowTemplate["zh-CN"].push {
  "_id": "493EA553-9A56-4AEC-ACC4-1F375FF90A3F",
  "name": "本周工作小结",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "created": "2017-09-21T06:03:10.731Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "8122c28c-a04b-43ef-aef2-edbbea85ea48",
    "_rev": 4,
    "created": "2017-09-21T10:10:12.091Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-21T10:14:05.818Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-21T10:10:12.091Z",
    "form": "493EA553-9A56-4AEC-ACC4-1F375FF90A3F",
    "name_forumla": "{部门}+{提交人}一周工作报告",
    "fields": [
      {
        "_id": "28CB76CB-ECDF-4E6C-A55C-3F5B4AD4F2DE",
        "code": "提交人",
        "is_required": true,
        "is_wide": false,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "formula": "{applicant.name}",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": true,
        "oldCode": "提交人"
      },
      {
        "_id": "FA098461-7C22-4B95-BC8D-3B41049B0BFB",
        "code": "部门",
        "is_required": true,
        "is_wide": false,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "formula": "{applicant.organization.name}",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": true,
        "is_searchable": true,
        "oldCode": "部门"
      },
      {
        "_id": "979EC3B9-05BE-42BF-A8C1-A0E2597AB2AF",
        "code": "本周工作小结",
        "is_required": true,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": true,
        "oldCode": "本周工作小结",
        "is_textarea": true
      },
      {
        "_id": "439FB7C4-1E93-4193-AA88-B986CCDDDB7E",
        "code": "未完成工作说明",
        "is_required": true,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": true,
        "oldCode": "未完成工作说明",
        "is_textarea": true
      },
      {
        "_id": "483C5240-5175-417D-857C-6305B63A6EC7",
        "code": "下周工作计划",
        "is_required": true,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": true,
        "is_searchable": true,
        "oldCode": "下周工作计划",
        "is_textarea": true
      },
      {
        "_id": "7E76C58A-D313-4E2D-BA8B-F1C0CCB1B2EA",
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
            "_id": "E955A6B4-ABE5-4446-8850-5B13BD0C868A",
            "code": "部门经理审核",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "部门经理审核",
            "is_textarea": true,
            "is_searchable": true
          },
          {
            "_id": "92522411-6681-4B3B-8994-111FD6B8F98F",
            "code": "总经理审批",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "总经理审批",
            "is_textarea": true,
            "is_searchable": true
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
  "historys": [],
  "category_name": "人事",
  "flows": [
    {
      "_id": "9884d234-ea18-4ed6-81f9-d2767c24609e",
      "name": "周工作报告",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "description": "",
      "is_valid": true,
      "form": "493EA553-9A56-4AEC-ACC4-1F375FF90A3F",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-21T06:03:10.731Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "help_text": "",
      "current_no": 0,
      "current": {
        "_id": "79ea1e36-28e5-432e-98c5-babbb942fca8",
        "_rev": 2,
        "flow": "9884d234-ea18-4ed6-81f9-d2767c24609e",
        "form_version": "8122c28c-a04b-43ef-aef2-edbbea85ea48",
        "modified": "2017-09-21T10:14:05.924Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-21T08:35:31.142Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-21T08:35:31.142Z",
        "steps": [
          {
            "_id": "41e1a601-a06f-4039-a6c3-1d6b809b1e59",
            "name": "开始(提交工作报告)",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 115.75,
            "posy": 257,
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
              "报告信息": "editable",
              "今日未完成计划及原因": "editable",
              "计划内容": "editable",
              "原因": "editable",
              "本周工作小结": "editable",
              "未完成工作说明": "editable",
              "下周工作计划": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "f532b2b6-3699-48e0-b75a-556e1534ea1c",
                "name": "",
                "state": "submitted",
                "to_step": "fa8dad99-bbeb-4bcb-a890-d40fd0a0c2c7",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "6f4b138b-7923-4357-857a-4235883e206a",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 901.25,
            "posy": 261,
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
            "_id": "fa8dad99-bbeb-4bcb-a890-d40fd0a0c2c7",
            "name": "判断提交人是否为部门经理？",
            "step_type": "condition",
            "deal_type": "",
            "description": "",
            "posx": 337,
            "posy": 255,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {},
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "5e627079-5aae-4ba4-b13f-c923a7757f44",
                "name": "",
                "state": "submitted",
                "condition": "({applicant.roles}.contains('部门经理') || {applicant.roles}.contains('办公室主任'))",
                "to_step": "3f8ead25-0e43-4726-ae98-fc94ab056745",
                "description": ""
              },
              {
                "_id": "283c59af-3e09-4827-9970-ddd2bc6d745a",
                "name": "",
                "state": "submitted",
                "condition": "!({applicant.roles}.contains('部门经理') || {applicant.roles}.contains('办公室主任'))",
                "to_step": "9526d99c-4ef5-44c2-baba-0c6eb2c35661",
                "description": ""
              },
              {
                "_id": "1ee01d2b-715c-40b3-8dd5-3704054c3be6",
                "name": "",
                "state": "submitted",
                "condition": "({applicant.roles}.contains('部门经理') || {applicant.roles}.contains('办公室主任'))",
                "to_step": "3971485b-15c8-45a8-97b6-ad464fdf3d5d",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "9526d99c-4ef5-44c2-baba-0c6eb2c35661",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 479,
            "posy": 137,
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
                "_id": "ec4abaa2-ec22-429c-9d94-933119ac2809",
                "name": "",
                "state": "approved",
                "to_step": "3971485b-15c8-45a8-97b6-ad464fdf3d5d",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "3f8ead25-0e43-4726-ae98-fc94ab056745",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 481,
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
                "_id": "05c5bfe3-2b12-4bb3-8523-a2a0ad5ed931",
                "name": "",
                "state": "approved",
                "to_step": "3971485b-15c8-45a8-97b6-ad464fdf3d5d",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "3971485b-15c8-45a8-97b6-ad464fdf3d5d",
            "name": "人事部备案",
            "step_type": "submit",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 710,
            "posy": 264,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "aHSKdRYwTRheTP6Sr"
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
                "_id": "9ec87417-ba58-4e6e-afac-ecb151790a7c",
                "name": "",
                "state": "submitted",
                "to_step": "6f4b138b-7923-4357-857a-4235883e206a",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "人事专员"
            ]
          }
        ]
      },
      "error_message": "",
      "app": "workflow",
      "distribute_optional_users": [],
      "historys": []
    }
  ]
}