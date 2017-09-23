#日常费用报销
workflowTemplate["zh-CN"].push {
  "_id": "64202a27ba13a62b56c41e82",
  "name": "日常费用报销",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "p5f5hYMFZBMRhKmNj",
  "created": "2017-09-22T07:09:04.959Z",
  "created_by": "5194c66ef4a563537a000003",
  "current": {
    "_id": "266bced3-fc32-42f9-b188-9097ecf5c098",
    "_rev": 7,
    "created": "2017-09-23T05:39:20.574Z",
    "created_by": "vmGnPPSnxepZeSLKh",
    "modified": "2017-09-23T05:39:20.662Z",
    "modified_by": "vmGnPPSnxepZeSLKh",
    "start_date": "2017-09-23T05:39:20.574Z",
    "form": "64202a27ba13a62b56c41e82",
    "form_script": "CoreForm.pageTitle= \"日常费用报销\";",
    "name_forumla": "{部门}+{提交人}+\"日常费用报销\"",
    "fields": [
      {
        "_id": "37162EF7-F3EF-47DA-A64B-1AA422C6EF69",
        "code": "提交人信息",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "提交人信息",
        "fields": [
          {
            "_id": "206383DA-EAE7-4FB9-919B-5EDBBD719496",
            "code": "提交人",
            "is_required": true,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{applicant.name}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "提交人",
            "is_searchable": true
          },
          {
            "_id": "7918F84F-8933-4059-AEC3-D2A7C17FCB09",
            "code": "职务",
            "default_value": "{applicant.position}",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "职务",
            "is_searchable": true
          },
          {
            "_id": "778B32AA-E1BC-43A9-8D68-BC878A800FF1",
            "code": "部门",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{applicant.organization.name}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "部门",
            "is_searchable": true
          }
        ]
      },
      {
        "_id": "DD8B4905-8249-4D7B-A9DD-13753DE4E9D7",
        "name": "",
        "code": "报销明细",
        "description": "",
        "is_required": false,
        "is_wide": true,
        "type": "table",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "报销明细",
        "subform_fields": [
          {
            "field_code": "bxmx",
            "width": 150
          },
          {
            "field_code": "bxje",
            "width": 150
          },
          {
            "field_code": "date",
            "width": 150
          },
          {
            "field_code": "bz",
            "width": 150
          }
        ],
        "fields": [
          {
            "_id": "747E9D68-4023-4B93-AFE5-269F8C1CF29C",
            "name": "",
            "code": "费用产生日期",
            "is_required": true,
            "is_wide": false,
            "type": "date",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "费用产生日期",
            "subform_fields": [],
            "is_searchable": false
          },
          {
            "name": "",
            "code": "费用类别",
            "default_value": "",
            "is_required": true,
            "is_wide": false,
            "type": "select",
            "rows": 4,
            "digits": 0,
            "options": "市内交通费\n餐费\n办公用品\n食品\n礼品\n其他",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "费用类别",
            "subform_fields": [],
            "is_searchable": true
          },
          {
            "_id": "D4CD0311-54EA-44DE-8068-A22037B4DAC8",
            "name": "",
            "code": "报销金额",
            "is_required": true,
            "is_wide": false,
            "type": "number",
            "rows": 4,
            "digits": 2,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "报销金额",
            "subform_fields": [],
            "is_searchable": true
          },
          {
            "_id": "F751069D-6A3E-4971-B4EB-5EE86556AC5F",
            "name": "",
            "code": "费用说明",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "费用说明",
            "subform_fields": [],
            "is_searchable": true
          }
        ]
      },
      {
        "_id": "3ABE1BC3-20C9-4622-AC94-D27B65B48F4C",
        "name": "",
        "code": "报销金额合计",
        "is_required": false,
        "is_wide": true,
        "type": "number",
        "rows": 4,
        "digits": 2,
        "formula": "sum({报销金额})",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": true,
        "is_searchable": true,
        "oldCode": "报销金额合计",
        "subform_fields": [],
        "fields": []
      },
      {
        "_id": "3FCE7A4D-7D90-4BCD-984A-A06BE1989F52",
        "code": "报销金额合计（大写）",
        "is_required": false,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "formula": "CoreForm.custom_numToCny({报销金额合计})",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": true,
        "oldCode": "报销金额合计（大写）",
        "is_textarea": false
      },
      {
        "_id": "5CA5D67F-AB0D-4D82-A788-8BD2D8AAE810",
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
            "_id": "385193C6-E878-406D-AF86-A0C2665C1BE7",
            "code": "部门领导意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'部门领导审核',default:'已阅'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "部门领导意见",
            "is_searchable": true
          },
          {
            "_id": "5244B9ED-27DF-421C-B83D-3A7CBCBD7057",
            "code": "办公室主任意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'办公室主任审核',default:'已阅'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "办公室主任意见",
            "is_searchable": true
          },
          {
            "_id": "0DE66071-5D42-4B79-8E77-CDE36CD0337E",
            "code": "财务部经理意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'财务部审核',default:'已阅'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "财务部经理意见",
            "is_searchable": true
          },
          {
            "_id": "94821DF4-C4C0-4750-A2E3-3D3117AFEAE7",
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
            "is_searchable": true
          }
        ]
      }
    ]
  },
  "enable_workflow": false,
  "enable_view_others": false,
  "app": "workflow",
  "category": "bbca535f64529f7b95b89782",
  "instance_style": "table",
  "is_subform": false,
  "import": true,
  "approve_on_create": false,
  "approve_on_modify": false,
  "approve_on_delete": false,
  "historys": [],
  "category_name": "财务",
  "instance_number_rules": [],
  "flows": [
    {
      "_id": "da95389b0c177b287b223249",
      "name": "日常费用报销",
      "name_formula": "",
      "code_formula": "",
      "space": "p5f5hYMFZBMRhKmNj",
      "is_valid": true,
      "form": "64202a27ba13a62b56c41e82",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-22T07:09:04.974Z",
      "created_by": "5194c66ef4a563537a000003",
      "current_no": 6,
      "current": {
        "_id": "6b0c3488-d407-45f3-b420-f910725b104b",
        "_rev": 6,
        "flow": "da95389b0c177b287b223249",
        "form_version": "266bced3-fc32-42f9-b188-9097ecf5c098",
        "modified": "2017-09-23T05:39:20.790Z",
        "modified_by": "vmGnPPSnxepZeSLKh",
        "created": "2017-09-23T05:39:20.574Z",
        "created_by": "vmGnPPSnxepZeSLKh",
        "start_date": "2017-09-23T05:39:20.574Z",
        "steps": [
          {
            "_id": "7B88738B-14CD-45EB-8A09-F54519EDA800",
            "name": "开始(提交申请)",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 8,
            "posy": 157.5,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {
              "subForm": "editable",
              "label": "editable",
              "文本": "editable",
              "文本1": "editable",
              "文本2": "editable",
              "__form": "editable",
              "职务": "editable",
              "报销明细": "editable",
              "费用产生日期": "editable",
              "费用类别": "editable",
              "报销金额": "editable",
              "费用说明": "editable",
              "审批意见": "editable",
              "提交人信息": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "42b14471-0e41-4662-8b26-02a272e4b66b",
                "name": "",
                "state": "submitted",
                "to_step": "69390b21-2ce2-4148-80f3-1eb4dd4ee094",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "d6a2d1a3-4a55-4d16-ae9a-c58007a2bcc2",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 985,
            "posy": 149,
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
                "_id": "aa3206cb-59fa-4223-bd09-a0ba4a5614df",
                "name": "",
                "state": "approved",
                "to_step": "fa2c3773-692f-49ac-954a-d120c1e612db",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "fa2c3773-692f-49ac-954a-d120c1e612db",
            "name": "提交人提交纸质报销单至财务部",
            "step_type": "submit",
            "deal_type": "applicant",
            "description": "",
            "posx": 746,
            "posy": 289,
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
                "_id": "9db05d4b-645a-44d4-ad0d-3302b078efd5",
                "name": "",
                "state": "submitted",
                "to_step": "fbb2fdb8-36e3-4648-9d6d-bd21ddbc2b84",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "f86187f1-6607-4c20-9cbd-88a808204ee0",
            "name": "财务部审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 580.587524414062,
            "posy": 149,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "hSQsvQw7jcbK3DLKt"
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
                "_id": "e0b2ea85-0648-4c4a-b82b-4151791b1f32",
                "name": "",
                "state": "approved",
                "to_step": "4a665d96-453f-4011-9157-c2725d305c53",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "财务部经理"
            ]
          },
          {
            "_id": "fbb2fdb8-36e3-4648-9d6d-bd21ddbc2b84",
            "name": "财务发放报销款",
            "step_type": "submit",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 762.337524414062,
            "posy": 440,
            "timeout_hours": 900,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "itzPjPiMpFa8jxtx6"
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
                "_id": "f8bfa846-19e3-44b3-a08a-f3ebf934bf0b",
                "name": "",
                "state": "submitted",
                "to_step": "074117aa-0d1d-4669-ba45-5791d134c55a",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "出纳"
            ]
          },
          {
            "_id": "9DAE3349-C888-47EC-A271-D61381F55985",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 785,
            "posy": 697.5,
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
            "_id": "4a665d96-453f-4011-9157-c2725d305c53",
            "name": "判断金额是否大于3000？",
            "step_type": "condition",
            "deal_type": "",
            "description": "",
            "posx": 749,
            "posy": 138,
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
                "_id": "788b8878-5cff-48e2-8d81-3ac8231c3beb",
                "name": "是",
                "state": "submitted",
                "condition": "{报销金额合计}>3000",
                "to_step": "d6a2d1a3-4a55-4d16-ae9a-c58007a2bcc2",
                "description": ""
              },
              {
                "_id": "b9ab558f-983a-4113-b647-e54f91a15d99",
                "name": "否",
                "state": "submitted",
                "condition": "{报销金额合计}<=3000",
                "to_step": "fa2c3773-692f-49ac-954a-d120c1e612db",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "5a1e8e66-04a9-4952-a872-17939a03d571",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 148,
            "posy": 148,
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
                "_id": "c6d73d23-213a-4794-9943-d1326e7cdcac",
                "name": "",
                "state": "approved",
                "to_step": "f322cbe3-6135-4679-8ea6-3c323b93ce8e",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "074117aa-0d1d-4669-ba45-5791d134c55a",
            "name": "提交人确认收款",
            "step_type": "submit",
            "deal_type": "applicant",
            "description": "",
            "posx": 762,
            "posy": 572,
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
                "_id": "18a1034b-e0a1-4f1f-8180-e76bd4c3ce80",
                "name": "",
                "state": "submitted",
                "to_step": "9DAE3349-C888-47EC-A271-D61381F55985",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "69390b21-2ce2-4148-80f3-1eb4dd4ee094",
            "name": "判断申请人是否为部门经理或办公室主任？",
            "step_type": "condition",
            "deal_type": "",
            "description": "",
            "posx": 184,
            "posy": 340,
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
                "_id": "43f82f88-bf87-41a3-b574-7885ad410aae",
                "name": "",
                "state": "submitted",
                "condition": "!({applicant.roles}.contains('部门经理') || {applicant.roles}.contains('办公室主任'))",
                "to_step": "5a1e8e66-04a9-4952-a872-17939a03d571",
                "description": ""
              },
              {
                "_id": "03c6e559-912c-4914-adb0-45068487c80b",
                "name": "",
                "state": "submitted",
                "condition": "{applicant.roles}.contains('部门经理') ||  {applicant.organization.name}='办公室'",
                "to_step": "f322cbe3-6135-4679-8ea6-3c323b93ce8e",
                "description": ""
              },
              {
                "_id": "7b5bf3bc-740b-4b55-b710-1c99c500f617",
                "name": "",
                "state": "submitted",
                "condition": "{applicant.roles}.contains('办公室主任')",
                "to_step": "f86187f1-6607-4c20-9cbd-88a808204ee0",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "f322cbe3-6135-4679-8ea6-3c323b93ce8e",
            "name": "办公室主任审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 344,
            "posy": 150,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "AqmH9zAvsmKqgASRj"
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
                "_id": "26985a8c-f418-4522-ab86-444a0e39d24f",
                "name": "",
                "state": "approved",
                "to_step": "f86187f1-6607-4c20-9cbd-88a808204ee0",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "办公室主任"
            ]
          }
        ]
      },
      "app": "workflow",
      "distribute_optional_users": [],
      "events": "CoreForm.custom_numToCny = function (num) {\n\nif(isNaN(num))return \"无效数值！\";\n\nvar strPrefix=\"\";\n\nif(num<0)strPrefix =\"(负)\";\n\nnum=Math.abs(num);\n\nif(num>=1000000000000)return \"无效数值！\";\n\nvar strOutput = \"\";\n\nvar strUnit = '仟佰拾亿仟佰拾万仟佰拾元角分';\n\nvar strCapDgt='零壹贰叁肆伍陆柒捌玖';\n\nnum += \"00\";\n\nvar intPos = num.indexOf('.');\n\nif (intPos >= 0){\n\nnum = num.substring(0, intPos) + num.substr(intPos + 1, 2);\n\n}\n\nstrUnit = strUnit.substr(strUnit.length - num.length);\n\nfor (var i=0; i < num.length; i++){\n\nstrOutput += strCapDgt.substr(num.substr(i,1),1) + strUnit.substr(i,1);\n\n}\n\nreturn strPrefix+strOutput.replace(/零角零分$/, '整').replace(/零[仟佰拾]/g, '零').replace(/零{2,}/g, '零').replace(/零([亿|万])/g, '$1').replace(/零+元/, '元').replace(/亿零{0,3}万/, '亿').replace(/^元/, \"零元\");\n\n};",
      "historys": []
    }
  ]
}