#会议纪要

workflowTemplate["zh-CN"].push {
  "_id": "8ff51be1c59cac0cb92ad047",
  "name": "会议纪要",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "created": "2017-09-14T02:28:49.438Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "09cf0cbc-3120-45e9-8ba5-2ac65270065d",
    "_rev": 6,
    "created": "2017-09-15T03:44:18.958Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-15T06:26:36.468Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-15T03:44:18.958Z",
    "form": "8ff51be1c59cac0cb92ad047",
    "form_script": "CoreForm.pageTitle= \"会议纪要\";",
    "fields": [
      {
        "_id": "13DE5C2F-660D-4393-B530-10D6290E3B71",
        "code": "会议信息",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "分组",
        "fields": [
          {
            "_id": "3111BDF6-4EB7-4D50-94C5-94DD39302323",
            "code": "会议标题",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "会议标题"
          },
          {
            "_id": "4523FF5F-FD5C-472B-B2D0-C947FD776F7E",
            "code": "会议时间",
            "is_required": false,
            "is_wide": false,
            "type": "date",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false
          },
          {
            "_id": "36733B84-E05D-4051-B8E6-6BA0FE581778",
            "code": "会议地点",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "会议地点"
          },
          {
            "_id": "06AD7E00-77C1-473C-AA60-956671CB3415",
            "code": "项目名称",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false
          },
          {
            "_id": "E005212D-E368-41CA-BB14-B30EBEDF0214",
            "code": "参会人员",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "参会人员"
          },
          {
            "_id": "C6D4160D-70B3-489C-8ECD-1257345C2D87",
            "code": "会议内容",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "会议内容",
            "is_textarea": true
          },
          {
            "_id": "D7E95C75-2826-404A-921C-3E958DB20AF3",
            "name": "",
            "code": "下一步工作安排",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "is_textarea": true
          }
        ]
      },
      {
        "_id": "0C23574F-4AD4-44F3-97B6-E9C6F624707C",
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
            "_id": "EA7FAF3F-ABC9-4968-8CEF-7AB05B904B11",
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
            "_id": "D91CEE9A-8C23-4D8D-957E-C18DBD91D686",
            "code": "相关部门会签意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'相关部门会签'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "会签意见",
            "is_textarea": true
          },
          {
            "_id": "DD8D5B4F-3E83-4C78-B322-65173861DF01",
            "code": "总经理意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'总经理审批'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "分管领导意见",
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
      "_id": "a6eac9bff91d99ce9511e91a",
      "name": "会议纪要",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "is_valid": true,
      "form": "8ff51be1c59cac0cb92ad047",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-14T02:28:49.465Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current_no": 1,
      "current": {
        "_id": "f63bbf3c-b327-496b-96ae-321cd59b2d1e",
        "_rev": 6,
        "flow": "a6eac9bff91d99ce9511e91a",
        "form_version": "09cf0cbc-3120-45e9-8ba5-2ac65270065d",
        "modified": "2017-09-15T06:26:36.589Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-15T03:44:18.958Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-15T03:44:18.958Z",
        "steps": [
          {
            "_id": "f96c3de0-4b13-4215-977d-bd507ccc1ba7",
            "name": "上传会议纪要及相关材料",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 125.25,
            "posy": 361.5,
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
              "会议标题": "editable",
              "会议开始时间": "editable",
              "会议地点": "editable",
              "参会人员": "editable",
              "会议信息": "editable",
              "日期-时间": "editable",
              "文本1": "editable",
              "文本2": "editable",
              "会议内容": "editable",
              "下一步工作安排": "editable",
              "项目名称": "editable",
              "会议时间": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "5a8d65f3-e9e7-4410-b57c-46ef494925e2",
                "name": "",
                "state": "submitted",
                "to_step": "f88babe6-1dd6-4cd8-8e76-dcdbf84985eb",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "fd9d7a3c-1c96-409d-8c02-23866a666ed8",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 710.25,
            "posy": 161.5,
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
            "_id": "f88babe6-1dd6-4cd8-8e76-dcdbf84985eb",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 334,
            "posy": 372,
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
                "_id": "ccba5a20-161f-4134-9657-49c8a189d489",
                "name": "",
                "state": "approved",
                "to_step": "9fd6964a-3575-4682-bbce-645c65ad2f1b",
                "description": ""
              },
              {
                "_id": "968a2794-5e32-40a2-a3e6-a09654e1e5f7",
                "name": "",
                "state": "approved",
                "to_step": "597e9ec9-0158-465d-a05c-7bb1382a2aca",
                "description": ""
              },
              {
                "_id": "61055e82-e1e8-4b63-8154-bae75704d611",
                "name": "",
                "state": "approved",
                "to_step": "e2c561da-b1c2-4c0c-82c5-9f3eea3f8eba",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "597e9ec9-0158-465d-a05c-7bb1382a2aca",
            "name": "提交人归档",
            "step_type": "submit",
            "deal_type": "applicant",
            "description": "",
            "posx": 553,
            "posy": 375,
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
                "_id": "449be732-839d-4a3c-8b67-558183d48a24",
                "name": "",
                "state": "submitted",
                "to_step": "fd9d7a3c-1c96-409d-8c02-23866a666ed8",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "9fd6964a-3575-4682-bbce-645c65ad2f1b",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 333,
            "posy": 203,
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
                "_id": "357cd8f4-f701-4243-ab52-165e5e216309",
                "name": "",
                "state": "approved",
                "to_step": "597e9ec9-0158-465d-a05c-7bb1382a2aca",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "e2c561da-b1c2-4c0c-82c5-9f3eea3f8eba",
            "name": "相关部门会签",
            "step_type": "counterSign",
            "deal_type": "pickupAtRuntime",
            "description": "",
            "posx": 329,
            "posy": 530,
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
                "_id": "cc6667ec-357e-4ac1-aa64-08caa740568b",
                "name": "",
                "state": "submitted",
                "to_step": "f88babe6-1dd6-4cd8-8e76-dcdbf84985eb",
                "description": ""
              }
            ],
            "approver_roles_name": []
          }
        ]
      },
      "app": "workflow",
      "distribute_optional_users": [],
      "historys": []
    }
  ]
}