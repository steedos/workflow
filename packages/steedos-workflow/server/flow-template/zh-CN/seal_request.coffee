#用印申请
workflowTemplate["zh-CN"].push {
  "_id": "2bb54be884a2421b03ea3545",
  "name": "用印申请",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "created": "2017-09-14T02:30:38.847Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "585063c8-fe42-45c4-ae54-ab6ca9025c03",
    "_rev": 3,
    "created": "2017-09-15T05:55:02.910Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-15T05:55:02.946Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-15T05:55:02.910Z",
    "form": "2bb54be884a2421b03ea3545",
    "form_script": "CoreForm.pageTitle= \"用印申请\";",
    "fields": [
      {
        "_id": "A35832CA-927A-48C7-9FEA-901E86CC6C6A",
        "code": "用印信息",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "用印信息",
        "fields": [
          {
            "_id": "7BD10A48-B7B2-4D94-8253-DF4439F979F7",
            "code": "申请人",
            "is_required": true,
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
            "_id": "39F53A3E-9F9B-43B5-B576-99223E764950",
            "code": "申请部门",
            "is_required": true,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{applicant.organization.name}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "申请部门"
          },
          {
            "_id": "ECEEFAC7-85EB-49B5-9107-6371A6B0D625",
            "code": "申请时间",
            "default_value": "{now}",
            "is_required": false,
            "is_wide": false,
            "type": "dateTime",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "申请时间"
          },
          {
            "_id": "584899E7-90AE-4DDA-8ADB-E2014F2B2F6C",
            "code": "印章类型",
            "default_value": "",
            "is_required": true,
            "is_wide": false,
            "type": "select",
            "rows": 4,
            "digits": 0,
            "options": "法人用章\n公章\n财务专用章\n合同专用章\n其他",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "印章类型"
          },
          {
            "_id": "140C60F1-BEC6-473A-8FF4-0B781ADF9E87",
            "code": "事由",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "事由",
            "is_textarea": true
          },
          {
            "_id": "FD1E5D35-C0F8-4A56-BC07-9369A51666C4",
            "code": "文件名称及内容",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "文件名称及内容",
            "is_textarea": true
          }
        ]
      },
      {
        "_id": "961372A5-FDE3-46C1-846C-B7C0F563296A",
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
            "_id": "67ECCEB6-1F47-43AE-AB47-F87DFE0EC16F",
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
            "_id": "62FEA1DD-00BE-458A-892E-258ED16DC6A6",
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
            "_id": "823708BD-BFDC-4D02-B973-9411915E8389",
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
      "_id": "94235abb12d14c17d7f20984",
      "name": "用印申请",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "is_valid": true,
      "form": "2bb54be884a2421b03ea3545",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-14T02:30:38.874Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current_no": 3,
      "current": {
        "_id": "720f5df1-533b-4167-b345-8b1f2ae000f5",
        "_rev": 4,
        "flow": "94235abb12d14c17d7f20984",
        "form_version": "585063c8-fe42-45c4-ae54-ab6ca9025c03",
        "modified": "2017-09-15T05:55:03.121Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-15T05:55:02.910Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-15T05:55:02.910Z",
        "steps": [
          {
            "_id": "d9ad1b1a-68b4-47d6-b769-fe9b6b8283fb",
            "name": "提交申请",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 152,
            "posy": 358.5,
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
              "用印信息": "editable",
              "印章类型": "editable",
              "日期": "editable",
              "申请时间": "editable",
              "事由": "editable",
              "文件名称及内容": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "8f5d0975-5cda-4863-a99c-75a8ad72fd96",
                "name": "",
                "state": "submitted",
                "to_step": "6395051b-de1a-41fe-91ad-3fd31f01a5ff",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "5c50cf37-a183-470e-99c7-46510692fc75",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 980.5,
            "posy": 357.5,
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
            "_id": "6395051b-de1a-41fe-91ad-3fd31f01a5ff",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 355,
            "posy": 361,
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
                "_id": "78d4065f-bac2-49c7-8ae4-9ca42b47fe6d",
                "name": "",
                "state": "approved",
                "to_step": "1276fc19-4098-4434-a7b5-dfef9d6ea9f2",
                "description": ""
              },
              {
                "_id": "7fa575fc-e978-4773-9a06-f0636407c065",
                "name": "",
                "state": "approved",
                "to_step": "2164a4c3-351b-4a83-b1ef-2d0caa9bc796",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "2164a4c3-351b-4a83-b1ef-2d0caa9bc796",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 600,
            "posy": 363,
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
                "_id": "3ef61f77-97e5-4387-a3fb-71e858a3dc3f",
                "name": "",
                "state": "approved",
                "to_step": "d33d1393-c98b-4f44-8d60-2dcc1581337a",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "1276fc19-4098-4434-a7b5-dfef9d6ea9f2",
            "name": "相关部门会签",
            "step_type": "counterSign",
            "deal_type": "pickupAtRuntime",
            "description": "",
            "posx": 353,
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
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "5eae8dd7-474e-40e3-b2c3-0b2b5f7fadec",
                "name": "",
                "state": "submitted",
                "to_step": "6395051b-de1a-41fe-91ad-3fd31f01a5ff",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "d33d1393-c98b-4f44-8d60-2dcc1581337a",
            "name": "申请人用印",
            "step_type": "submit",
            "deal_type": "applicant",
            "description": "",
            "posx": 794,
            "posy": 360,
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
                "_id": "090d0328-1608-4705-b73f-0f9d05f0d513",
                "name": "",
                "state": "submitted",
                "to_step": "5c50cf37-a183-470e-99c7-46510692fc75",
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