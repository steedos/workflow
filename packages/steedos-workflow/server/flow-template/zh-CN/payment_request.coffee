#申请付款

workflowTemplate["zh-CN"].push {
  "_id": "23f73bf03e4cf8f04437c90f",
  "name": "申请付款",
  "state": "enabled",
  "is_deleted": false,
  "is_valid": true,
  "space": "51ae9b1a8e296a29c9000001",
  "created": "2017-09-14T02:30:10.840Z",
  "created_by": "kFePuCYbpHCe7R6dT",
  "current": {
    "_id": "e24e89c5-2a41-4c52-b583-9de6de965e44",
    "_rev": 3,
    "created": "2017-09-14T08:48:17.395Z",
    "created_by": "kFePuCYbpHCe7R6dT",
    "modified": "2017-09-15T06:59:13.327Z",
    "modified_by": "kFePuCYbpHCe7R6dT",
    "start_date": "2017-09-14T08:48:17.395Z",
    "form": "23f73bf03e4cf8f04437c90f",
    "form_script": "CoreForm.pageTitle= \"付款申请\";",
    "fields": [
      {
        "_id": "EBB2059C-1D90-45FD-A78B-58F27AFEA7D3",
        "code": "付款信息",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "付款信息",
        "fields": [
          {
            "_id": "E9CA4B0D-5235-47AA-A855-1C51078BE2D7",
            "code": "收款单位",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "收款单位"
          },
          {
            "_id": "BB9C30F1-C059-44B7-A9AE-939D0024510E",
            "code": "所属合同",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "所属合同"
          },
          {
            "_id": "986899CF-701B-4106-AAB5-4C58BAA7E924",
            "code": "项目预算",
            "is_required": false,
            "is_wide": false,
            "type": "number",
            "rows": 4,
            "digits": 2,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "项目预算"
          },
          {
            "_id": "6B156AE5-FC2E-43DC-BF76-A366DCD70122",
            "code": "本次付款金额",
            "is_required": true,
            "is_wide": false,
            "type": "number",
            "rows": 4,
            "digits": 2,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "本次付款金额"
          },
          {
            "_id": "385BF89B-FB2B-464F-94EE-AF94361D6664",
            "code": "本次付款金额（大写）",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "CoreForm.custom_numToCny({本次付款金额})",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "本次付款金额（大写）"
          },
          {
            "_id": "9343186C-88D1-4A4A-A286-4BC7AD8CBF67",
            "code": "已付金额",
            "is_required": false,
            "is_wide": false,
            "type": "number",
            "rows": 4,
            "digits": 2,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "已付金额"
          },
          {
            "_id": "E3CB3F9C-4626-4509-A79D-370A52603315",
            "code": "付款方式",
            "default_value": "银行汇款",
            "is_required": true,
            "is_wide": false,
            "type": "select",
            "rows": 4,
            "digits": 0,
            "options": "银行汇款\n现金\n支票",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "付款方式"
          },
          {
            "_id": "CB2155C1-C5B4-4017-AE80-219EC0A9163B",
            "code": "收款方开户银行",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "收款方开户银行"
          },
          {
            "_id": "3329BC46-442B-4116-92FE-BE1F9047F740",
            "code": "收款方银行账号",
            "is_required": false,
            "is_wide": false,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "收款方银行账号"
          },
          {
            "_id": "53630054-C58A-4AFD-9B58-C63B5C0DCD68",
            "code": "付款原因",
            "is_required": true,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "付款原因",
            "is_textarea": true
          },
          {
            "_id": "756566C5-87A3-48B3-825B-B071127B2AAB",
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
        "_id": "CB6E7F0D-6B81-472C-A851-DCB88C75D0E0",
        "name": "审批意见",
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
            "_id": "BFCB1D0C-A121-4B44-A10A-1925F0902CE2",
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
            "_id": "90ACD5AD-AA12-41F4-83C4-0235E8495D46",
            "name": "办公室主任意见",
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
            "_id": "9873D41D-77EF-4A76-9D21-CD53A71217B3",
            "code": "财务部经理意见",
            "is_required": false,
            "is_wide": true,
            "type": "input",
            "rows": 4,
            "digits": 0,
            "formula": "{yijianlan:{step:'财务部审核'}}",
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "财务部经理意见",
            "is_textarea": true,
            "is_list_display": false
          },
          {
            "_id": "76B5E443-A5BC-489D-8F4C-735DF5808D16",
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
      },
      {
        "_id": "F90B0DA9-322D-48F5-8090-71B3B7C74D03",
        "name": "",
        "code": "财务填写",
        "default_value": "",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "财务填写",
        "subform_fields": [],
        "fields": [
          {
            "_id": "0EA6D78F-7A59-4AD5-8B44-9F656F918316",
            "name": "",
            "code": "实际付款日期",
            "is_required": true,
            "is_wide": false,
            "type": "date",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "实际付款日期"
          }
        ]
      },
      {
        "_id": "4B1FCC8F-326F-4C11-846D-29750E33223D",
        "name": "",
        "code": "提交人确认",
        "default_value": "",
        "is_required": false,
        "is_wide": true,
        "type": "section",
        "rows": 4,
        "digits": 0,
        "has_others": false,
        "is_multiselect": false,
        "is_list_display": false,
        "is_searchable": false,
        "oldCode": "提交人确认",
        "subform_fields": [],
        "fields": [
          {
            "_id": "841D69FE-0A35-4E98-A312-7AAC56678095",
            "code": "确认到款日",
            "is_required": true,
            "is_wide": false,
            "type": "date",
            "rows": 4,
            "digits": 0,
            "has_others": false,
            "is_multiselect": false,
            "oldCode": "确认到款日"
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
      "_id": "397a7414666498c0316ca302",
      "name": "申请付款",
      "name_formula": "",
      "code_formula": "",
      "space": "51ae9b1a8e296a29c9000001",
      "is_valid": true,
      "form": "23f73bf03e4cf8f04437c90f",
      "flowtype": "new",
      "state": "enabled",
      "is_deleted": false,
      "created": "2017-09-14T02:30:10.864Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current_no": 2,
      "current": {
        "_id": "88522262-83eb-4dca-bf3f-ab1527727a0e",
        "_rev": 3,
        "flow": "397a7414666498c0316ca302",
        "form_version": "e24e89c5-2a41-4c52-b583-9de6de965e44",
        "modified": "2017-09-15T06:59:13.483Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-14T08:46:59.113Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2017-09-14T08:46:59.113Z",
        "steps": [
          {
            "_id": "430331D2-2CD3-4387-95A4-999CD9967302",
            "name": "提交申请",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 15,
            "posy": 234,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {
              "开户银行": "editable",
              "日期": "editable",
              "收款耽误": "editable",
              "__form": "editable",
              "付款信息": "editable",
              "收款单位": "editable",
              "所属合同": "editable",
              "本次付款金额": "editable",
              "已付金额": "editable",
              "项目预算": "editable",
              "付款方式": "editable",
              "收款方开户银行": "editable",
              "收款方银行账号": "editable",
              "付款原因": "editable",
              "备注": "editable",
              "审批意见": "editable"
            },
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "lines": [
              {
                "_id": "9153ae08-89d2-4a89-b9fa-b2e80132880e",
                "name": "",
                "state": "submitted",
                "to_step": "ec81a3f2-65e3-46c3-bb8d-f0a1efa4e6ea",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "4334bac0-2567-4b43-b057-497fdceb9b27",
            "name": "财务执行付款",
            "step_type": "submit",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 853,
            "posy": 273,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "530ad822334904539e000ae9"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {
              "财务填写": "editable",
              "实际付款日期": "editable"
            },
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "717c507c-7ed7-4d20-9423-883c4122b95d",
                "name": "",
                "state": "submitted",
                "to_step": "6d6a8774-bc67-4f8f-9d22-172c1d25141e",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "出纳"
            ]
          },
          {
            "_id": "6d6a8774-bc67-4f8f-9d22-172c1d25141e",
            "name": "申请人确认",
            "step_type": "submit",
            "deal_type": "applicant",
            "description": "",
            "posx": 1035,
            "posy": 272,
            "timeout_hours": 30,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "permissions": {
              "提交人确认": "editable",
              "确认到款日": "editable"
            },
            "disableCC": false,
            "allowDistribute": false,
            "can_edit_main_attach": false,
            "can_edit_normal_attach": true,
            "distribute_optional_flows": [],
            "cc_must_finished": false,
            "cc_alert": false,
            "lines": [
              {
                "_id": "060e716a-7ec2-4f13-bfcb-b466edf69009",
                "name": "",
                "state": "submitted",
                "to_step": "B90F379F-55E9-4D9F-A036-D9DBD1A9EC55",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "B90F379F-55E9-4D9F-A036-D9DBD1A9EC55",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 1201,
            "posy": 274,
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
            "_id": "d7e333b4-2931-46e7-b297-78092a6a4920",
            "name": "总经理审批",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 698.097229003906,
            "posy": 107.097229003906,
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
                "_id": "6f78945f-3d60-451b-a9d1-0f1d36d6f705",
                "name": "",
                "state": "approved",
                "to_step": "4334bac0-2567-4b43-b057-497fdceb9b27",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          },
          {
            "_id": "ec81a3f2-65e3-46c3-bb8d-f0a1efa4e6ea",
            "name": "部门领导审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 150,
            "posy": 234,
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
                "_id": "e62ce26c-0657-4fad-bf5c-40d06cd2aeb2",
                "name": "",
                "state": "approved",
                "to_step": "e2f8dd41-b425-4ba3-846b-b28020a18f09",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "部门经理"
            ]
          },
          {
            "_id": "9063109d-6d4c-4099-88d8-ac8fd65173b0",
            "name": "财务部审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 374,
            "posy": 463,
            "timeout_hours": 168,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "51af1dd18e296a29c900007f"
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
                "_id": "d82150d4-ec00-4771-89d2-5607bbb5e23d",
                "name": "",
                "state": "approved",
                "to_step": "1694fd48-939d-4b95-bba8-9bcf34b82849",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "财务部经理"
            ]
          },
          {
            "_id": "e2f8dd41-b425-4ba3-846b-b28020a18f09",
            "name": "办公室主任审核",
            "step_type": "sign",
            "deal_type": "applicantRole",
            "description": "",
            "posx": 359,
            "posy": 236,
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
                "_id": "bed4df9f-3d02-4b4a-bd57-4d93fe571897",
                "name": "",
                "state": "approved",
                "to_step": "9063109d-6d4c-4099-88d8-ac8fd65173b0",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "办公室主任"
            ]
          },
          {
            "_id": "1694fd48-939d-4b95-bba8-9bcf34b82849",
            "name": "金额是否大于3000？",
            "step_type": "condition",
            "deal_type": "",
            "description": "",
            "posx": 547,
            "posy": 344,
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
                "_id": "653f2c96-6e50-403d-8679-96f234a5163c",
                "name": "",
                "state": "submitted",
                "condition": "{本次付款金额}>3000",
                "to_step": "d7e333b4-2931-46e7-b297-78092a6a4920",
                "description": ""
              },
              {
                "_id": "675c9645-ce30-4065-a0cc-340a55ec1b0a",
                "name": "",
                "state": "submitted",
                "condition": "{本次付款金额}<=3000",
                "to_step": "4334bac0-2567-4b43-b057-497fdceb9b27",
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
    },
    {
      "_id": "cbc19ed81cc899377ce104c6",
      "app": "workflow",
      "code_formula": "{YY}-{MM}-{NNNN}",
      "created": "2017-09-14T02:30:10.915Z",
      "created_by": "kFePuCYbpHCe7R6dT",
      "current": {
        "_id": "0f86ea72d091e7307e191aa1",
        "_rev": 1,
        "flow": "cbc19ed81cc899377ce104c6",
        "form_version": "96d76933f141a335dfcd3baa",
        "modified": "2017-09-14T02:30:10.920Z",
        "modified_by": "kFePuCYbpHCe7R6dT",
        "created": "2017-09-14T02:30:10.920Z",
        "created_by": "kFePuCYbpHCe7R6dT",
        "start_date": "2013-06-07T04:06:41.728Z",
        "finish_date": "2013-06-07T04:14:49.513Z",
        "steps": [
          {
            "_id": "06AA20E6-F9A7-4A6C-AD9B-069828E51E05",
            "name": "开始",
            "step_type": "start",
            "deal_type": "",
            "description": "",
            "posx": 467.0000228881836,
            "posy": 88.4814682006836,
            "timeout_hours": 30,
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "fields_modifiable": [
              "SUPPLYER",
              "PROJECT",
              "SUM",
              "EXPECTEDFAYINGDATE",
              "BANKNAME",
              "REASON",
              "BANKACCOUNT",
              "REMARKS"
            ],
            "permissions": {
              "SUPPLYER": "editable",
              "PROJECT": "editable",
              "SUM": "editable",
              "EXPECTEDFAYINGDATE": "editable",
              "BANKNAME": "editable",
              "REASON": "editable",
              "BANKACCOUNT": "editable",
              "REMARKS": "editable"
            },
            "lines": [
              {
                "_id": "BE58BA4A-77BB-4B04-BD79-6C4D8E8ABD84",
                "name": "",
                "state": "submitted",
                "to_step": "ea92b6f1-d51d-4723-bccf-3fc0beb15c96",
                "order": "1",
                "description": ""
              }
            ],
            "approver_roles_name": []
          },
          {
            "_id": "4802C9B4-21B7-4B61-88E9-BB7EC78829D2",
            "name": "结束",
            "step_type": "end",
            "deal_type": "",
            "description": "",
            "posx": 496.0000228881836,
            "posy": 267.4815139770508,
            "timeout_hours": 30,
            "approver_roles": [],
            "approver_orgs": [],
            "approver_users": [],
            "fields_modifiable": [],
            "lines": [],
            "approver_roles_name": []
          },
          {
            "_id": "ea92b6f1-d51d-4723-bccf-3fc0beb15c96",
            "name": "单签",
            "step_type": "sign",
            "deal_type": "specifyUser",
            "description": "",
            "posx": 613.1296615600586,
            "posy": 154.62963104248047,
            "timeout_hours": 30,
            "approver_user_field": "",
            "approver_org_field": "",
            "approver_roles": [
              "51af1b2f8e296a29c9000063"
            ],
            "approver_orgs": [],
            "approver_users": [],
            "approver_step": "",
            "fields_modifiable": [],
            "lines": [
              {
                "_id": "4c39ce17-c283-4249-a7bf-69b4fb2505f6",
                "name": "",
                "state": "approved",
                "to_step": "4802C9B4-21B7-4B61-88E9-BB7EC78829D2",
                "order": "1",
                "description": ""
              }
            ],
            "approver_roles_name": [
              "总经理"
            ]
          }
        ]
      },
      "current_no": 0,
      "flowtype": "new",
      "form": "23f73bf03e4cf8f04437c90f",
      "is_deleted": true,
      "is_valid": false,
      "name": "新流程",
      "name_formula": "新流程",
      "space": "51ae9b1a8e296a29c9000001",
      "state": "disabled",
      "historys": []
    }
  ]
}