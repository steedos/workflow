FlowRouter.route '/api/qiyeweixin/main',
	action: (params, queryParams)->
		FlowRouter.go 'https://www.bing.com/?mkt=zh-CN'