@SogoNotification = {}
SogoNotification._sound = new Audio('/sound/notification.mp3')
SogoNotification._timeout = 6 * 1000

###
data参数格式：
{
    "quotas": {
        "maxQuota": "1048576",
        "usedSpace": "4610"
    },
    "headers": [
        ["To", "hasAttachment", "isFlagged", "Subject", "From", "isRead", "Priority", "RelativeDate", "Size", "Flags", "uid", "isAnswered", "isForwarded"],
        [
            [{
                "name": "殷亮辉",
                "email": "yinlianghui@steedos.cn"
            }], 0, 0, "\"Personal Address Book\" has been created", [{
                "name": "殷亮辉",
                "email": "yinlianghui@steedos.cn"
            }], 1, {
                "name": "一般",
                "level": 3
            }, "08-十一月-18", "2.2 KiB", [], 1, 0, 0
        ]
		...
    ],
    "threaded": 0,
    "unseenCount": 1,
    "uids": [7, 6, 5, 4, 3, 2, 1]
}
###
SogoNotification.send = (data) ->
	headers = data.headers
	unseenCount = data.unseenCount
	unless unseenCount
		return
	account = AccountManager._auth
	unless account
		return
	# https://mail.steedos.cn/SOGo/so/yinlianghui@steedos.cn/Mail/view#!/Mail/0/INBOX/5
	sogoWebURL = Meteor.settings.public?.sogoWebURL
	inboxPath = "#{sogoWebURL}/so/#{account.user}/Mail/view#!/Mail/0/INBOX/"
	if unseenCount > 1
		title = '新邮件'
		body = '您有' + unseenCount + '封新邮件'
		openUrl = inboxPath
	else
		uid = headers[1][10]
		subject = headers[1][3]
		from = headers[1][4]
		if from[0].name
			title = from[0].name
		else
			title = from[0].email
		body = subject
		openUrl = inboxPath + uid
	options = 
		iconUrl: Meteor.absoluteUrl() + 'images/apps/workflow/AppIcon48x48.png'
		title: title
		body: body
		timeout: SogoNotification._timeout

	options.onclick = ->
		# var domainsArr = FlowRouter._current.path.split("/");
		# FlowRouter.go openUrl

	$.notification options
	# 任务栏高亮显示
	nw.Window.get().requestAttention 3
	SogoNotification._sound.play()
