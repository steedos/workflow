#请示报告
workflowTemplate["zh-CN"].push {
  "_id": "b87f4e15ab3e143c25d77307",
  "name": "请示报告",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "created": "2017-09-14T02:29:19.243Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "69105b39-f32d-49e6-a809-827e2b64bec0",
    "_rev": 2,
    "created": "2017-09-15T05:59:38.812Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-15T05:59:38.845Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-15T05:59:38.812Z",
    "form": "b87f4e15ab3e143c25d77307",
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
        "is_searchable": false,
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
        "is_list_display": false,
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
        "is_list_display": false,
        "is_searchable": false,
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
        "is_searchable": false,
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
        "is_searchable": false,
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
            "is_textarea": true
          },
          {
            "_id": "E15E0D02-5ED8-4F2F-B2F5-220911BCD0F0",
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
            "_id": "5CFE8DB3-E27C-4F05-B85C-8EC0ADE353E8",
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
      "_id": "1ba35d93ccdeebf1c766b208",
      "name": "请示报告",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "is_valid": true,
      "form": "b87f4e15ab3e143c25d77307",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-14T02:29:19.270Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current_no": 2,
      "current": {
        "_id": "7057769b-0592-461e-ac08-94af6ef71341",
        "_rev": 3,
        "flow": "1ba35d93ccdeebf1c766b208",
        "form_version": "69105b39-f32d-49e6-a809-827e2b64bec0",
        "modified": "2017-09-15T05:59:39.045Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-14T08:52:38.607Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-14T08:52:38.607Z",
        "steps": [
          {
            "_id": "96c24165-7a31-424c-b2ba-51874f30cbbb",
            "name": "提交申请",
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
            "posx": 353.625,
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
                "_id": "1e7cc106-4679-4622-b350-446b48010276",
                "name": "",
                "state": "approved",
                "to_step": "01165a51-a082-46d9-8dad-33b71a0aee8b",
                "description": ""
              },
              {
                "_id": "b9a18591-8f38-4121-af2c-234898edee3e",
                "name": "",
                "state": "approved",
                "to_step": "26443a1e-b94d-4f30-9421-6a2416059e72",
                "description": ""
              },
              {
                "_id": "24ff18ee-a4fe-4d84-8ca5-63ba379445e3",
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
      "app": "workflow",
      "distribute_optional_users": [
        {
          "id": "2iRmNeoYoJyCbqgMh",
          "name": "后勤公司文书"
        },
        {
          "id": "3oGZwSrZ9ivNBEfLn",
          "name": "地产发展公司文书"
        },
        {
          "id": "42QF4ohZdDJ9aavas",
          "name": "监理公司文书"
        },
        {
          "id": "6SrSzEWDrMbviAMDq",
          "name": "港立电梯文书"
        },
        {
          "id": "7fqq8r96vdZWhSyoX",
          "name": "通信公司文书"
        },
        {
          "id": "8Aty6nqgLwv5bFH9D",
          "name": "东方石油公司文书"
        },
        {
          "id": "BWsZFYAeWaqTjxDLG",
          "name": "国际物流公司文书"
        },
        {
          "id": "BYnzWDYSTFWaDh88E",
          "name": "检测公司文书"
        },
        {
          "id": "G8hB7dqY3wy824aCK",
          "name": "港口工程公司文书"
        },
        {
          "id": "JWm5guRnzjjseYPjX",
          "name": "蓝港国旅文书"
        },
        {
          "id": "LZA8ATaPYGTBKdEQS",
          "name": "社保中心文书"
        },
        {
          "id": "LhvHKSZqLqLZHK7WZ",
          "name": "之海公司文书"
        },
        {
          "id": "Qd3NBaKMNdwRCYspA",
          "name": "邯郸陆港公司文书"
        },
        {
          "id": "QrZJ6CzEf3A39iQTN",
          "name": "睿港煤炭物流公司文书"
        },
        {
          "id": "Rt3DpsHcQiuiDjd73",
          "name": "方远公司文书"
        },
        {
          "id": "TbqfayKwFLj82GbX2",
          "name": "环渤海交易中心文书"
        },
        {
          "id": "ThE6aW56Bm6sdesDA",
          "name": "方宇公司文书"
        },
        {
          "id": "TsLyja6KaL4rquwkM",
          "name": "港口医院文书"
        },
        {
          "id": "WwxqvzdCi6NskDLj2",
          "name": "离退中心文书"
        },
        {
          "id": "YHM6sP5QXzhSRZ2qA",
          "name": "香港公司文书"
        },
        {
          "id": "aCXZ8iiyeomgtdrYk",
          "name": "餐饮公司文书"
        },
        {
          "id": "akWEPo3WPHfzZjGP2",
          "name": "股份公司文书"
        },
        {
          "id": "bNNiW2Yye644dL6Rm",
          "name": "物资中心文书"
        },
        {
          "id": "fa7QTyk6jnoZwtsXp",
          "name": "行政管理中心(房产管理中心)文书"
        },
        {
          "id": "jZKdgzcp8wMdztrCY",
          "name": "结算中心文书"
        },
        {
          "id": "jxqzkNpNCgXW5SnFL",
          "name": "港口机械公司文书"
        },
        {
          "id": "kJdc5Hq9bNTNTiEvz",
          "name": "水运卫校文书"
        },
        {
          "id": "m6DZBg4xHHFJp96sg",
          "name": "海景酒店文书"
        },
        {
          "id": "nB6Q5J3MeL5sdZTNK",
          "name": "新闻中心文书"
        },
        {
          "id": "nnWoKvzrQs6oaRPa2",
          "name": "财务公司文书"
        },
        {
          "id": "rMyqYukCW7886e8YG",
          "name": "公安局文书"
        },
        {
          "id": "sW975DY7YAG8cbnQa",
          "name": "教育中心文书"
        },
        {
          "id": "sbe3cTmZFgjgXzort",
          "name": "水暖公司文书"
        },
        {
          "id": "sxH59mZk4RhiCqyqD",
          "name": "资产公司文书"
        },
        {
          "id": "wBtgWzfYMxjWGPh4q",
          "name": "外代文书"
        },
        {
          "id": "wg33BPWncpayFYjMM",
          "name": "港口协会文书"
        },
        {
          "id": "xwyGeRnRiyPcS5bdS",
          "name": "秦仁海运文书"
        },
        {
          "id": "yK8jyn3HqPqfgsczf",
          "name": "港口宾馆文书"
        }
      ],
      "distribute_to_self": true,
      "historys": []
    }
  ]
}