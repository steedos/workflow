workflowTemplate = {}

#可用此脚本从模板工作区做批量导出：
#使用管理员账户登录后，进入FlowModules，在控制台执行以下脚本即可
#db.forms.find({state:"enabled"}).forEach(function(form){window.open(Meteor.absoluteUrl("api/workflow/export/form?form="+form._id))})
workflowTemplate["en"] =[]

#可用此脚本从模板工作区做批量导出：
#使用管理员账户登录后，进入模板专区，在控制台执行以下脚本即可
#db.forms.find({state:"enabled"}).forEach(function(form){window.open(Meteor.absoluteUrl("api/workflow/export/form?form="+form._id))})
workflowTemplate["zh-CN"] =[]