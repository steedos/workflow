# 请示报告
workflowTemplate["zh-CN"].push {
  "_id": "e2cdc13848b51d181618bc80",
  "name": "请示报告",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "p5f5hYMFZBMRhKmNj",
  "description": "",
  "created": "2017-09-22T07:09:05.118Z",
  "created_by": "5194c66ef4a563537a000003",
  "current": {
    "_id": "d7378075-937a-4c74-bd5c-961518d2a6ec",
    "_rev": 4,
    "created": "2017-09-23T03:02:39.838Z",
    "created_by": "51edf12c49203b28da000012",
    "modified": "2017-09-23T03:03:27.277Z",
    "modified_by": "51edf12c49203b28da000012",
    "start_date": "2017-09-23T03:02:39.838Z",
    "form": "e2cdc13848b51d181618bc80",
    "form_script": "CoreForm.pageTitle= \"请示报告\";",
    "name_forumla": "{文件标题}",
    "fields": [
      {
        "_id": "05799A4D-4104-4A9F-89BB-226C3BAD25B0",
        "name": "文件编号",
        "code": "文件编号",
        "default_value": "auto_number(请示报告)",
        "is_required": false,
        "is_wide": false,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": true,
        "oldCode": "文件编号"
      },
      {
        "_id": "E994556D-7D6E-45B0-B5EC-843250334310",
        "name": "文件日期",
        "code": "文件日期",
        "default_value": "{now}",
        "is_required": false,
        "is_wide": false,
        "type": "date",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": true,
        "is_searchable": false,
        "oldCode": "文件日期"
      },
      {
        "_id": "47AE2F56-9B0B-4C99-AAE1-34424829575D",
        "code": "请示部门",
        "default_value": "",
        "is_required": false,
        "is_wide": false,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "formula": "{applicant.organization.fullname}",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": true,
        "is_searchable": true,
        "oldCode": "请示部门"
      },
      {
        "_id": "35A060B9-5B14-4609-A54F-BC0322987C2D",
        "name": "标题",
        "code": "文件标题",
        "is_required": true,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": true,
        "oldCode": "文件标题",
        "is_textarea": false
      },
      {
        "_id": "C9029294-9DAA-4FF7-AAF7-9A32C8B09D0C",
        "code": "备注",
        "is_required": false,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": true,
        "oldCode": "备注",
        "is_textarea": true
      },
      {
        "_id": "E3C02B27-1DDD-46C6-95F7-26D47E6838CE",
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
            "_id": "764A0D37-A7A8-4CC2-AA6B-78F1145B22FF",
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
            "is_textarea": true,
            "is_searchable": true
          },
          {
            "_id": "E15E0D02-5ED8-4F2F-B2F5-220911BCD0F0",
            "code": "部门会签意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'相关部门会签',default:'已阅'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "部门会签意见",
            "is_textarea": true,
            "is_searchable": true
          },
          {
            "_id": "5CFE8DB3-E27C-4F05-B85C-8EC0ADE353E8",
            "code": "总经理意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'总经理审批',default:'已阅'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "总经理意见",
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
  "category": "de12374c584e54677ccf1e23",
  "instance_style": "table",
  "is_subform": false,
  "import": true,
  "historys": [],
  "category_name": "行政",
  "instance_number_rules": [
    {
      "name": "请示报告",
      "first_number": 1,
      "rules": "{YYYY}-QSBG-{NUMBER}",
      "year": 2017,
      "number": 0
    }
  ],
  "flows": [
    {
      "_id": "3a52f0b77d9ac76d7f35ed84",
      "name": "请示报告",
      "name_formula": "",
      "code_formula": "",
      "space": "p5f5hYMFZBMRhKmNj",
      "is_valid": false,
      "form": "e2cdc13848b51d181618bc80",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-22T07:09:05.145Z",
      "created_by": "5194c66ef4a563537a000003",
      "current_no": 6,
      "current": {
        "_id": "b50936d4-9fff-458c-a16e-2eebb77f5e9d",
        "_rev": 2,
        "flow": "3a52f0b77d9ac76d7f35ed84",
        "form_version": "d7378075-937a-4c74-bd5c-961518d2a6ec",
        "modified": "2017-09-23T03:03:27.375Z",
        "modified_by": "51edf12c49203b28da000012",
        "created": "2017-09-23T02:56:43.329Z",
        "created_by": "51edf12c49203b28da000012",
        "start_date": "2017-09-23T02:56:43.329Z",
        "steps": [
          {
            "_id": "96c24165-7a31-424c-b2ba-51874f30cbbb",
            "name": "开始(提交申请)",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 120.125,
            "posy": 259.5,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {
              "文件标题": "editable",
              "备注": "editable",
              "__form": "editable",
              "标头": "editable",
              "文件编号": "editable",
              "文件日期": "editable",
              "审批意见": "editable",
              "文本2": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "f658eb70-85fa-4c46-b4f4-641ede89b50f",
                "name": "",
                "state": "submitted",
                "to_step": "0b9b4287-5636-4fb1-bb76-63385e05d665",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "0fc202b9-3785-482a-ab98-49f1e60ed019",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 351.625,
            "posy": 441.5,
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
            "_id": "01165a51-a082-46d9-8dad-33b71a0aee8b",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 536,
            "posy": 259,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "2EXJTFGNWKhvtreBv"
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
                "_id": "bc6aa60a-bcd4-4595-8bc6-91ab7621f4e8",
                "name": "",
                "state": "approved",
                "to_step": "0b9b4287-5636-4fb1-bb76-63385e05d665",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "0b9b4287-5636-4fb1-bb76-63385e05d665",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 339,
            "posy": 258,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "h6krqeiiRBQurhnH4"
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
                "_id": "4f1e2d19-7da7-4925-b438-5233b285f93a",
                "name": "",
                "state": "approved",
                "to_step": "26443a1e-b94d-4f30-9421-6a2416059e72",
                "description": ""
              },
              {
                "_id": "32e07238-e872-4567-8765-ee626ab7e957",
                "name": "",
                "state": "approved",
                "to_step": "01165a51-a082-46d9-8dad-33b71a0aee8b",
                "description": ""
              },
              {
                "_id": "f2ac335b-84c8-45c7-b45c-218c291eca5f",
                "name": "",
                "state": "approved",
                "to_step": "0fc202b9-3785-482a-ab98-49f1e60ed019",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "26443a1e-b94d-4f30-9421-6a2416059e72",
            "name": "相关部门会签",
            "step_type": "counterSign",
            "deal_type": "pickupAtRuntime",
            "description": "",
            "posx": 338,
            "posy": 108,
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
                "_id": "4e3d8cd3-f336-4e0f-9d34-0679f8a9b6e4",
                "name": "",
                "state": "submitted",
                "to_step": "0b9b4287-5636-4fb1-bb76-63385e05d665",
                "description": ""
              }
            ],
            "approver_roles_name": []
          }
        ]
      },
      "distribute_optional_users": [],
      "historys": []
    }
  ]
}