TracesTemplate.helpers =
	equals: (a, b) ->
		a == b
	empty: (a) ->
		if a
			a.toString().trim().length < 1
		else
			true
	unempty: (a) ->
		if a
			a.toString().trim().length > 0
		else
			false
	append: (a, b) ->
		a + b
	dateFormat: (date) ->
		$.format.date new Date(date), "yyyy-MM-dd HH:mm"
	getStepName: (stepId) ->
		step = WorkflowManager.getInstanceStep(stepId)
		if step
			return step.name
		null
	showDeleteButton: (approved) ->
		if approved and approved.type == 'cc' and approved.from_user == Meteor.userId() and approved.is_finished != true and !Session.get("instancePrint")
			return true
		false
	isCC: (approved) ->
		if approved and approved.type == 'cc'
			return true
		false
	getApproveStatusIcon: (approveJudge) ->
		#已结束的显示为核准/驳回/取消申请，并显示处理状态图标
		approveStatusIcon = undefined
		switch approveJudge
			when 'approved'
				# 已核准
				approveStatusIcon = 'ion ion-checkmark-round'
			when 'rejected'
				# 已驳回
				approveStatusIcon = 'ion ion-close-round'
			when 'terminated'
				# 已取消
				approveStatusIcon = 'fa fa-ban'
			when 'reassigned'
				# 转签核
				approveStatusIcon = 'ion ion-android-contact'
			when 'relocated'
				# 重定位
				approveStatusIcon = 'ion ion-arrow-shrink'
			when 'retrieved'
				# 已取回
				approveStatusIcon = 'fa fa-undo'
			else
				approveStatusIcon = ''
				break
		approveStatusIcon
	getApproveStatusText: (approveJudge) ->
		if Meteor.isServer
			locale = Template.instance().view.template.steedosData.locale
			if locale.toLocaleLowerCase() == 'zh-cn'
				locale = "zh-CN"
		else
			locale = Session.get("TAPi18n::loaded_lang")
		#已结束的显示为核准/驳回/取消申请，并显示处理状态图标
		approveStatusText = undefined
		switch approveJudge
			when 'approved'
				# 已核准
				approveStatusText = TAPi18n.__('Instance State approved', {}, locale)
			when 'rejected'
				# 已驳回
				approveStatusText = TAPi18n.__('Instance State rejected', {}, locale)
			when 'terminated'
				# 已取消
				approveStatusText = TAPi18n.__('Instance State terminated', {}, locale)
			when 'reassigned'
				# 转签核
				approveStatusText = TAPi18n.__('Instance State reassigned', {}, locale)
			when 'relocated'
				# 重定位
				approveStatusText = TAPi18n.__('Instance State relocated', {}, locale)
			when 'retrieved'
				# 已取回
				approveStatusText = TAPi18n.__('Instance State retrieved', {}, locale)
			else
				approveStatusText = ''
				break
		approveStatusText
	_t: (key)->
		return TAPi18n.__(key)

	myApproveDescription: (approveId)->
		if Meteor.isClient
			if InstanceManager.isInbox()
				myApprove = InstanceManager.getCurrentApprove()
				if myApprove && myApprove.id == approveId
					return Session.get("instance_my_approve_description")

if Meteor.isServer
	TracesTemplate.helpers.dateFormat = (date)->
		if date
			utcOffset = Template.instance().view.template.steedosData.utcOffset
			return InstanceReadOnlyTemplate.formatDate(date, utcOffset);

	TracesTemplate.helpers._t = (key)->
		locale = Template.instance().view.template.steedosData.locale
		return TAPi18n.__(key, {}, locale)

	TracesTemplate.helpers.showDeleteButton = (approved) ->
		return false;

TracesTemplate.events =
	'click .cc-approve-remove': (event, template) ->
		event.stopPropagation()
		if event.currentTarget.dataset.calling * 1 != 1
			event.currentTarget.dataset.calling = 1
			$("i",event.currentTarget).addClass("fa-spin")
			instanceId = Session.get('instanceId')
			approveId = event.target.dataset.approve
			# CALL 删除approve函数。
			$("body").addClass("loading")
			Meteor.call 'cc_remove', instanceId, approveId, (err, result) ->
				$("body").removeClass("loading")
				if err
					toastr.error err
					event.currentTarget.dataset.calling = 0
					$("i",event.currentTarget).removeClass("fa-spin")
				if result == true
					toastr.success(TAPi18n.__("remove_cc_approve"));
					if $(".instance-trace-detail-modal").length
						Modal.hide "instance_trace_detail_modal"
				return
			return

	'click .instance-trace-detail-modal .btn-cc-approve-remove': (event, template) ->
		instanceId = Session.get('instanceId')
		approveId = event.target.dataset.approve
		# CALL 删除approve函数。
		$("body").addClass("loading")
		Meteor.call 'cc_remove', instanceId, approveId, (err, result) ->
			$("body").removeClass("loading")
			if err
				toastr.error err
			if result == true
				toastr.success(TAPi18n.__("remove_cc_approve"));
				Modal.hide "instance_trace_detail_modal"
			return
		return

	'click .approve-item': (event, template) ->
		Modal.show "instance_trace_detail_modal", this

	'click .instance-trace-detail-modal .btn-close': (event, template) ->
		Modal.hide "instance_trace_detail_modal"
		
