#收文
workflowTemplate["zh-CN"].push {
  "_id": "8b8f52b153213dbabdf8f0a3",
  "name": "收文单",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "created": "2017-09-14T02:30:22.032Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "1bbb7ce5-d303-46ed-9bcd-5aabbdaa3917",
    "_rev": 3,
    "created": "2017-09-15T05:53:08.220Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-15T06:41:44.419Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-15T05:53:08.220Z",
    "form": "8b8f52b153213dbabdf8f0a3",
    "form_script": "CoreForm.pageTitle= \"收文单\";",
    "name_forumla": "",
    "fields": [
      {
        "_id": "0DF6EB50-F899-4D7B-BB8B-2A06F141D7EB",
        "name": "收文号",
        "code": "收文号",
        "default_value": "",
        "is_required": false,
        "is_wide": false,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "收文号",
        "is_textarea": false
      },
      {
        "_id": "7A6E55C9-D6F6-4FA4-890A-24D4CE69EBC5",
        "code": "收文日期",
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
        "oldCode": "收文日期"
      },
      {
        "_id": "B56042D8-B9B3-4402-8CEE-4EE82AC456BE",
        "name": "来文单位",
        "code": "来文单位",
        "default_value": "",
        "is_required": false,
        "is_wide": false,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "来文单位"
      },
      {
        "_id": "E643229F-0DA3-4C70-B60A-DB06F1AD6342",
        "name": "缓急程度",
        "code": "priority",
        "default_value": "普通",
        "is_required": false,
        "is_wide": false,
        "type": "select",
        "rows": 4,
        "digits": 0,
        "options": "普通\n紧急\n特急\n办文",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "priority"
      },
      {
        "_id": "6B610DA9-1C71-4AB8-BB83-E1B7F898530A",
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
        "_id": "221DDE91-57E8-4B1F-8324-96864174055E",
        "name": "文件编号",
        "code": "文件编号",
        "default_value": "auto_number(收文)",
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
        "_id": "C80B2B4C-82F2-41FA-9225-1D276EAC68F9",
        "name": "",
        "code": "文件标题",
        "default_value": "",
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
        "_id": "9B167C53-4344-4134-8CD1-F86F198E0A58",
        "code": "办公室主任意见",
        "is_required": false,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "formula": "{yijianlan:{step:'办公室主任审核'}}",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "办公室主任意见",
        "is_textarea": true
      },
      {
        "_id": "878FC9FC-446D-4EB2-B8E8-5241701AC9A0",
        "name": "",
        "code": "领导意见",
        "is_required": false,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "formula": "{yijianlan:{step:'领导阅签'}}",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "领导意见",
        "is_textarea": true
      },
      {
        "_id": "83AC0EB3-18AD-47F7-B155-B2FC29A80266",
        "code": "承办结果",
        "is_required": false,
        "is_wide": true,
        "type": "input",
        "rows": 4,
        "digits": 0,
        "formula": "{yijianlan:{step:'相关部门阅办'}}",
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "承办结果",
        "is_textarea": true
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
      "_id": "1785eff8614d107cb72dcab3",
      "name": "收文",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "is_valid": true,
      "form": "8b8f52b153213dbabdf8f0a3",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-14T02:30:22.060Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current_no": 2,
      "current": {
        "_id": "86006131-8455-48f0-b9d8-d589aaea0880",
        "_rev": 2,
        "flow": "1785eff8614d107cb72dcab3",
        "form_version": "1bbb7ce5-d303-46ed-9bcd-5aabbdaa3917",
        "modified": "2017-09-15T06:41:44.513Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-15T05:52:47.884Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-15T05:52:47.884Z",
        "steps": [
          {
            "_id": "a7b742ad-f1c9-423c-9bea-db426f76a2f0",
            "name": "收文登记",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 115.75,
            "posy": 369,
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
              "收文日期": "editable",
              "文件标题": "editable",
              "手写编号": "editable",
              "来文编号": "editable",
              "标头": "editable",
              "priority": "editable",
              "来文单位": "editable",
              "收文号": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "d33074cb-6af4-4acb-9132-954b0921ec2c",
                "name": "",
                "state": "submitted",
                "to_step": "dbcd13fb-8c1f-4d78-9451-532bcdc9c02d",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "67ed8dac-c3e3-4fd9-ba0e-0b769119d9c4",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 545.25,
            "posy": 541.458312988281,
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
            "_id": "2354ecab-c44a-4b2e-b890-dfc461390991",
            "name": "文书处理",
            "step_type": "submit",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 543,
            "posy": 369,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "A7C8iZDuwJCniMgo5"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {
              "标头": "editable",
              "文件日期": "editable",
              "文件编号": "editable"
            },
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": true,
            "lines": [
              {
                "_id": "7ab9899d-1f14-4fcd-8c2b-cfe39e1c5723",
                "name": "",
                "state": "submitted",
                "to_step": "4f705f0f-f200-4641-9ae8-884ffaeb4d75",
                "description": ""
              },
              {
                "_id": "1c3129b3-b8d3-4390-8415-1e03da88ff6f",
                "name": "",
                "state": "submitted",
                "to_step": "a41a86d2-cd5a-4e6e-9217-a2828eca331a",
                "description": ""
              },
              {
                "_id": "233f4432-a7b3-45e7-ab9c-6baedff0917a",
                "name": "",
                "state": "submitted",
                "to_step": "67ed8dac-c3e3-4fd9-ba0e-0b769119d9c4",
                "description": ""
              },
              {
                "_id": "c4488316-817b-499d-8e2b-d98e8b380564",
                "name": "",
                "state": "submitted",
                "to_step": "dbcd13fb-8c1f-4d78-9451-532bcdc9c02d",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "办公室文书"
            ]
          },
          {
            "_id": "4f705f0f-f200-4641-9ae8-884ffaeb4d75",
            "name": "领导阅签",
            "step_type": "counterSign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 761.888916015625,
            "posy": 366.888885498047,
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
                "_id": "327c691d-e972-4410-892e-aea62dbb9081",
                "name": "",
                "state": "submitted",
                "to_step": "2354ecab-c44a-4b2e-b890-dfc461390991",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "公司领导"
            ]
          },
          {
            "_id": "a41a86d2-cd5a-4e6e-9217-a2828eca331a",
            "name": "相关部门阅办",
            "step_type": "counterSign",
            "deal_type": "pickupAtRuntime",
            "description": "",
            "posx": 533,
            "posy": 193,
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
                "_id": "8a9b00e6-7619-4fe0-9bd3-b6c1abfdb9f8",
                "name": "",
                "state": "submitted",
                "to_step": "2354ecab-c44a-4b2e-b890-dfc461390991",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "dbcd13fb-8c1f-4d78-9451-532bcdc9c02d",
            "name": "办公室主任审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 315,
            "posy": 369,
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
                "_id": "13e4210e-e58e-46c0-a96e-9475d2f8deca",
                "name": "",
                "state": "approved",
                "to_step": "2354ecab-c44a-4b2e-b890-dfc461390991",
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
          "name": "物流管理部（国际物流公司）文书"
        },
        {
          "id": "BYnzWDYSTFWaDh88E",
          "name": "检测公司文书"
        },
        {
          "id": "CCcMXeWLpaGva73fr",
          "name": "资本运营部（投资管理公司）文书"
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
      "historys": []
    }
  ]
}