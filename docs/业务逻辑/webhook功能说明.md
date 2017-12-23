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

- 当用户提交申请单时触发webhook，给payload_url发送POST request请求
- 请求的body数据为：
```javascript
{
	current_approve: {}, // 用户执行提交操作时的approve数据
	instance: {} // 提交申请单操作完成后最新的完整的实例数据
}
``` 