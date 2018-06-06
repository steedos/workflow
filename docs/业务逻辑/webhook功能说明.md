# webhook功能说明
## 用途
- 当用户提交申请单时触发配置好的webhook执行额外的操作

## 规则
- 管理员在webhook设置中配置webhook相关内容
- webhook表结构
```javascript
{
    _id: "", // 主键
    space: "", // 工作区id
    flow: "", // 流程id
    payload_url: "", // 请求的url，即管理员设置的url
    content_type: "application/json", // 请求时数据格式
    active: "", // 是否激活
    description: "" // 描述
}
```

- 当用户操作申请单时触发webhook，给payload_url发送POST request请求
- 请求发送的body数据有如下：
  - action：触发此hook时的操作，值域：
    draft_submit(草稿箱提交)，
    engine_submit(待审核提交)，
    reassign(转签核)，
    relocate(重定位)，
    retrieve(取回)，
    terminate(取消申请)，
    cc_do(传阅给他人)，
    cc_submit(被传阅提交)

  - from_user：值为当前操作者。如： A提交申请单给B 那么from_user值就是A的id\username\emails

    - _id：用户在审批王的唯一标识符

    - username：用户登录名

    - emails：用户配置的邮箱列表

      - address：邮箱地址

      - verified：邮箱是否验证

      - primary：邮箱是否主要邮箱

  - to_users：值为发送者集合。

  - current_approve：用户执行提交操作时的approve数据

  - instance：提交申请单操作完成后最新的完整的实例数据

body数据示例如下：
```javascript
{
	"action": "draft_submit",
    "from_user": {
        "_id":  "TPWYx597AuLSksSDH",
        "username":  "AAA",
        "emails":  [{
                    address: "AAA@hotoa.com",
                    verified: true,
                    primary: true
                },{
                    address: "AAA1@hotoa.com",
                    verified: true,
                    primary: false
                }]
        },
    "to_users": [{
        "_id":  "snLab9tq6bHquJjof",
        "username":  "BBB",
        "emails":  [{
                    address: "BBB@hotoa.com",
                    verified: true,
                    primary: true
                },{
                    address: "BBB1@hotoa.com",
                    verified: false,
                    primary: false
                }]
        },{
        "_id":  "hJChDEqfCh5MQ2tGj",
        "username":  "CCC",
        "emails":  [{
                    address: "CCC@hotoa.com",
                    verified: true,
                    primary: true
                }]
        }],
    "current_approve": {
        "_id": "8ecbd6be43193e650e8d913f",
        "instance": "HjHvRxp5vFL5fn7uK",
        "trace": "b0f6eadb4b7909538778d766",
        "is_finished": false,
        "user": "hPgDcEd9vKQxwndQR",
        "user_name": "MJ",
        "handler": "hPgDcEd9vKQxwndQR",
        "handler_name": "MJ",
        "handler_organization": "593b97230cda012fa65270f9",
        "handler_organization_name": "华炎软件",
        "handler_organization_fullname": "华炎软件",
        "type": "draft",
        "is_read": true,
        "is_error": false,
        "description": "",
        "values": {
            "拟稿人": "MJ",
            "日期-时间": "",
            "日期": "",
            "文件标题": "公司发文",
            "下拉框": "",
            "多选": ""
        },
        "judge": "submitted",
        "next_steps": [
            {
                "step": "b65e5d4a-3d52-4aa6-a7c9-260cb7242ca6",
                "users": [
                    "hPgDcEd9vKQxwndQR"
                ]
            }
        ]
    }, 
    "instance": {
        "_id": "HjHvRxp5vFL5fn7uK",
        "space": "Af8eM6mAHo7wMDqD3",
        "flow": "0c09ae80-6e44-4d77-96f7-c1efa19e26ce",
        "flow_version": "561295cb-c262-4ee3-9659-2f6350155406",
        "form": "6B0DCFC3-1E39-4F70-8C5D-E80C135CD70D",
        "form_version": "672de6ce-e372-48e9-b1d3-830b46819b0b",
        "name": "公司发文",
        "submitter": "hPgDcEd9vKQxwndQR",
        "submitter_name": "MJ",
        "applicant": "hPgDcEd9vKQxwndQR",
        "applicant_name": "MJ",
        "applicant_organization": "593b97230cda012fa65270f9",
        "applicant_organization_name": "华炎软件",
        "applicant_organization_fullname": "华炎软件",
        "state": "pending",
        "code": "21",
        "is_archived": false,
        "is_deleted": false,
        "values": {
            "拟稿人": "MJ",
            "日期-时间": "",
            "日期": "",
            "文件标题": "公司发文",
            "下拉框": "",
            "多选": ""
        },
        "traces": [
            {
                "_id": "b0f6eadb4b7909538778d766",
                "instance": "HjHvRxp5vFL5fn7uK",
                "is_finished": true,
                "step": "9b680fbe-0429-4dc8-913e-688c4cbebd3b",
                "name": "拟稿人拟稿",
                "start_date": "2017-12-08T09:00:52.422Z",
                "approves": [
                    {
                        "_id": "8ecbd6be43193e650e8d913f",
                        "instance": "HjHvRxp5vFL5fn7uK",
                        "trace": "b0f6eadb4b7909538778d766",
                        "is_finished": true,
                        "user": "hPgDcEd9vKQxwndQR",
                        "user_name": "MJ",
                        "handler": "hPgDcEd9vKQxwndQR",
                        "handler_name": "MJ",
                        "handler_organization": "593b97230cda012fa65270f9",
                        "handler_organization_name": "华炎软件",
                        "handler_organization_fullname": "华炎软件",
                        "type": "draft",
                        "is_read": true,
                        "is_error": false,
                        "description": "",
                        "values": {
                            "拟稿人": "MJ",
                            "日期-时间": "",
                            "日期": "",
                            "文件标题": "公司发文",
                            "下拉框": "",
                            "多选": ""
                        },
                        "judge": "submitted",
                        "next_steps": [
                            {
                                "step": "b65e5d4a-3d52-4aa6-a7c9-260cb7242ca6",
                                "users": [
                                    "hPgDcEd9vKQxwndQR"
                                ]
                            }
                        ],
                        "cost_time": 177759
                    }
                ],
                "judge": "submitted"
            }
        ],
        "inbox_users": [
            "hPgDcEd9vKQxwndQR"
        ],
        "current_step_name": "主任签发",
        "submit_date": "2017-12-08T09:03:50.189Z",
        "outbox_users": [],
        "keywords": ""
    }
}
```
