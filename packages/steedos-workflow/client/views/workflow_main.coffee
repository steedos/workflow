Template.workflow_main.helpers 

	instanceId: ->
		return Session.get("instanceId")

	instance_loading: ->
		return Session.get("instance_loading")
		
	subsReady: ->
		return Steedos.subsBootstrap.ready() and Steedos.subsSpace.ready();

	isNeedToShowInstance: ->
		if Steedos.subs["Instance"].ready()
			Session.set("instance_loading", false);
			instance = WorkflowManager.getInstance()
			if instance
				if Session.get("box") == "inbox"
					if InstanceManager.isInbox()
						return true
					else
						FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box") + "/")
				else
					return true
			else # 订阅完成 instance 不存在，则认为instance 已经被删除
				FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box") + "/")
		return false

Template.workflow_main.onCreated ->


Template.workflow_main.onRendered ->
