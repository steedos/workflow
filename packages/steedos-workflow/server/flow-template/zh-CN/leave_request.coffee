#请假申请

workflowTemplate["zh-CN"].push {
  "_id": "6cf576e09308ec1acac7d760",
  "name": "请假申请",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "description": "",
  "created": "2017-09-14T02:29:02.434Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "242e06e9-9c07-4ac9-81fc-ddd40bfc8ccb",
    "_rev": 3,
    "created": "2017-09-15T05:58:20.831Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-15T05:58:20.873Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-15T05:58:20.831Z",
    "form": "6cf576e09308ec1acac7d760",
    "form_script": "CoreForm.pageTitle= \"请假申请\";",
    "fields": [
      {
        "_id": "9DEF3353-60DC-471A-B714-077290D7B2E9",
        "code": "申请人信息",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "申请人信息",
        "fields": [
          {
            "_id": "9308A421-18B1-4D87-B248-133CE31AB6EF",
            "code": "申请人",
            "default_value": "",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{applicant.name}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "申请人"
          },
          {
            "_id": "9355BC45-8D6B-4750-A4F7-C2B86345430C",
            "code": "职务",
            "default_value": "{applicant.position}",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false
          },
          {
            "_id": "D8C23ABD-5B8F-464C-88BA-6F0E8AA72B92",
            "code": "部门",
            "default_value": "",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{applicant.organization.name}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "部门信息"
          },
          {
            "_id": "E66F7465-A205-4C45-A7A9-027EC9C9134C",
            "code": "联系电话",
            "default_value": "{applicant.mobile}",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "联系电话"
          }
        ]
      },
      {
        "_id": "4BDD090A-7254-4E05-9771-A3FB0F15B79C",
        "code": "请假信息",
        "description": "说明：请假天数非自动计算，请手工输入",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "请假信息",
        "fields": [
          {
            "_id": "684D420B-2DAB-4401-8714-27B5AC6E9DBB",
            "code": "请假类别",
            "default_value": "",
            "is_required": true,
            "is_wide": false,
            "type": "select",
            "rows": 4,
            "digits": 0,
            "options": "事假\n病假\n年假\n调休\n婚假\n产假\n产检假\n丧假",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "请假类别"
          },
          {
            "_id": "051D86ED-2335-4B4D-82DD-79EB4F8369B5",
            "name": "请假天数",
            "code": "tianshu",
            "is_required": true,
            "is_wide": false,
            "type": "number",
            "rows": 4,
            "digits": 1,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "tianshu"
          },
          {
            "_id": "B039BCD4-E682-4FAD-917C-51B72E4B0829",
            "name": "开始时间",
            "code": "starttime",
            "is_required": true,
            "is_wide": false,
            "type": "dateTime",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "starttime"
          },
          {
            "_id": "C7D39D1D-E484-47B8-BAE1-1794D1CB1FA4",
            "name": "结束时间",
            "code": "endtime",
            "is_required": true,
            "is_wide": false,
            "type": "dateTime",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "endtime"
          },
          {
            "_id": "31AEBF53-3395-4312-BC7C-B4A44604E51B",
            "name": "请假事由",
            "code": "note",
            "is_required": true,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "note",
            "is_textarea": true
          }
        ]
      },
      {
        "_id": "B2C99CE3-827A-4BE3-B2FC-330A4EB5C2F4",
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
        "fields": [
          {
            "_id": "40122076-CED7-4AC0-8A96-E64F419EE516",
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
            "_id": "9FB5F1B1-C0E6-4297-9A77-F86C549B360B",
            "name": "总经理意见",
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
  "approve_on_create": false,
  "approve_on_modify": false,
  "approve_on_delete": false,
  "import": true,
  "historys": [],
  "category_name": "基本流程模板",
  "flows": [
    {
      "_id": "ca06b32f47002ce1c8b89795",
      "name": "请假申请",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "is_valid": true,
      "form": "6cf576e09308ec1acac7d760",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-14T02:29:02.453Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current_no": 2,
      "current": {
        "_id": "911d0047-0008-45d6-980d-522c11a37a91",
        "_rev": 3,
        "flow": "ca06b32f47002ce1c8b89795",
        "form_version": "242e06e9-9c07-4ac9-81fc-ddd40bfc8ccb",
        "modified": "2017-09-15T05:58:21.086Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-15T05:58:20.831Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-15T05:58:20.831Z",
        "steps": [
          {
            "_id": "6830383D-DB38-4352-A988-E29712A12C92",
            "name": "提交申请",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 83,
            "posy": 225,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {
              "qingjialeixing": "editable",
              "请假天数": "editable",
              "开始时间（9:00、12:30）": "editable",
              "结束时间（11:30、18:00）": "editable",
              "请假理由": "editable",
              "__form": "editable",
              "申请人信息": "editable",
              "数值": "editable",
              "请假类别": "editable",
              "请假信息": "editable",
              "tianshu": "editable",
              "starttime": "editable",
              "endtime": "editable",
              "note": "editable",
              "审批意见": "editable",
              "文本1": "editable",
              "联系电话": "editable",
              "职务": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "c0c0b021-2e7f-49f6-a67b-8a1a4d8564a2",
                "name": "",
                "state": "submitted",
                "to_step": "dca98bef-0702-4934-ab48-6a8f79f8843c",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "10A03FAF-687A-4C49-B66A-880418C6DAA0",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 1166,
            "posy": 241,
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
            "_id": "83d3b9a3-d876-4983-9d4d-772aa61bcf42",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 395.083343505859,
            "posy": 446.069458007812,
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
                "_id": "8b6061ac-e492-4feb-b224-8021989cef54",
                "name": "",
                "state": "approved",
                "to_step": "8f1100e3-2b99-4014-b00e-706a610de158",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "c65c9841-8801-4254-947e-8dff87c08ea0",
            "name": "判断请假天数是否大于3天？",
            "step_type": "condition",
            "deal_type": "",
            "description": "",
            "posx": 610,
            "posy": 164,
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
                "_id": "967dd23d-795c-4590-90a9-0368b1a8631a",
                "name": "",
                "state": "submitted",
                "condition": "{tianshu}>1",
                "to_step": "83d3b9a3-d876-4983-9d4d-772aa61bcf42",
                "description": ""
              },
              {
                "_id": "82a931e7-aaad-414e-8dc7-ed2834e3a95b",
                "name": "",
                "state": "submitted",
                "condition": "{tianshu}<=1",
                "to_step": "8f1100e3-2b99-4014-b00e-706a610de158",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "850fdaad-5c8f-487f-a2e4-4f8e9e59e793",
            "name": "通知申请人",
            "step_type": "submit",
            "deal_type": "applicant",
            "description": "",
            "posx": 995,
            "posy": 249,
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
                "_id": "75a9030f-b5c4-4737-a200-b1054826162e",
                "name": "",
                "state": "submitted",
                "to_step": "10A03FAF-687A-4C49-B66A-880418C6DAA0",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "8f1100e3-2b99-4014-b00e-706a610de158",
            "name": "人事部备案",
            "step_type": "submit",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 809,
            "posy": 247,
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
                "_id": "9b2852c3-faa9-44a6-a892-ca131f4b86f7",
                "name": "",
                "state": "submitted",
                "to_step": "850fdaad-5c8f-487f-a2e4-4f8e9e59e793",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "人事专员"
            ]
          },
          {
            "_id": "bf09e1b6-5ad9-4c3b-8df9-40471cbb6415",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 444,
            "posy": 109,
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
                "_id": "886f3070-a986-423f-822b-48e172940d7a",
                "name": "",
                "state": "approved",
                "to_step": "c65c9841-8801-4254-947e-8dff87c08ea0",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "dca98bef-0702-4934-ab48-6a8f79f8843c",
            "name": "判断提交人是否为部门经理？",
            "step_type": "condition",
            "deal_type": "",
            "description": "",
            "posx": 260,
            "posy": 227,
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
                "_id": "e5c7ea32-5613-48a2-9172-d1c741a9a346",
                "name": "",
                "state": "submitted",
                "condition": "!({applicant.roles}.contains('部门经理') || {applicant.roles}.contains('办公室主任'))",
                "to_step": "bf09e1b6-5ad9-4c3b-8df9-40471cbb6415",
                "description": ""
              },
              {
                "_id": "c5f208cc-97d0-405c-a188-e9aa6ea2d4aa",
                "name": "",
                "state": "submitted",
                "condition": "({applicant.roles}.contains('部门经理') || {applicant.roles}.contains('办公室主任'))",
                "to_step": "83d3b9a3-d876-4983-9d4d-772aa61bcf42",
                "description": ""
              }
            ],
            "approver_roles_name": []
          }
        ]
      },
      "app": "workflow",
      "distribute_optional_users": [],
      "events": "//如果开始时间大于结束时间，弹出警告，并且不能提交\n$(\"[name='starttime']\").on(\"change\",function(e){\n  if(AutoForm.getFieldValue('endtime', 'instanceform')){\n    var endtime = new Date(AutoForm.getFieldValue('endtime', 'instanceform'));\n    var starttime = new Date($(this).val());\n    if (endtime-starttime<=0)\n        swal(\n\t    {\n\t    title:\"结束时间必须大于开始时间\",\n\t    type:\"warning\",\n\t    confirmButtonText:\"确定\"\n\t    });\n    }\n  }\n)\n$(\"[name='endtime']\").on(\"change\",function(e){\n  if(AutoForm.getFieldValue('starttime', 'instanceform')){\n    var starttime = new Date(AutoForm.getFieldValue('starttime', 'instanceform'));\n    var endtime = new Date($(this).val());\n    if (endtime-starttime<=0)\n        swal(\n\t    {\n\t    title:\"结束时间必须大于开始时间\",\n\t    type:\"warning\",\n\t    confirmButtonText:\"确定\"\n\t    });\n    }\n  }\n)\n\n$(\".instance-form\").on('instance-before-submit', function(e) {\n    if(AutoForm.getFieldValue('starttime', 'instanceform')>=AutoForm.getFieldValue('endtime', 'instanceform'))\n                {\n\t\t\tswal(\n\t\t\t\t    {\n\t\t\t\t    title:\"结束时间必须大于开始时间\",\n\t\t\t\t    type:\"warning\",\n\t\t\t\t    confirmButtonText:\"确定\"\n\t\t\t\t    });\n                        e.preventDefault();\n\t\t\t        }\n}\n )",
      "historys": []
    }
  ]
}