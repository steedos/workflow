Template.instance_button.helpers

	enabled_save: ->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		flow = db.flows.findOne(ins.flow);
		if !flow
			return false

		if InstanceManager.isInbox()
			return true

		if !ApproveManager.isReadOnly()
			return true
		else
			return false

	enabled_delete: ->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		space = db.spaces.findOne(ins.space);
		if !space
			return false

		if Session.get("box") == "draft" || (Session.get("box") == "monitor" && space.admins.contains(Meteor.userId()))
			return true
		else
			return false

	enabled_print: ->
#		如果是手机版APP，则不显示打印按钮
		if Meteor.isCordova
			return false
		return true


	enabled_add_attachment: ->
		if !ApproveManager.isReadOnly()
			return true
		else
			return false

	enabled_terminate: ->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		if (Session.get("box") == "pending" || Session.get("box") == "inbox") && ins.state == "pending" && ins.applicant == Meteor.userId()
			return true
		else
			return false

	enabled_reassign: ->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		space = db.spaces.findOne(ins.space);
		if !space
			return false
		fl = db.flows.findOne({'_id': ins.flow});
		if !fl
			return false
		curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
		if !curSpaceUser
			return false
		organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
		if !organizations
			return false

		if Session.get("box") == "monitor" && ins.state == "pending" && (space.admins.contains(Meteor.userId()) || WorkflowManager.canAdmin(fl, curSpaceUser, organizations))
			return true
		else
			return false

	enabled_relocate: ->
		ins = WorkflowManager.getInstance();
		if !ins
			return false
		space = db.spaces.findOne(ins.space);
		if !space
			return false
		fl = db.flows.findOne({'_id': ins.flow});
		if !fl
			return false
		curSpaceUser = db.space_users.findOne({space: ins.space, 'user': Meteor.userId()});
		if !curSpaceUser
			return false
		organizations = db.organizations.find({_id: {$in: curSpaceUser.organizations}}).fetch();
		if !organizations
			return false

		if Session.get("box") == "monitor" && ins.state != "draft" && (space.admins.contains(Meteor.userId()) || WorkflowManager.canAdmin(fl, curSpaceUser, organizations))
			return true
		else
			return false

	enabled_cc: ->
		ins = WorkflowManager.getInstance()
		if !ins
			return false

		if InstanceManager.isInbox() && ins.state != "draft"
			return true
		else
			return false

	enabled_forward: ->
		ins = WorkflowManager.getInstance()
		if !ins
			return false

		if ins.state != "draft"
			return true
		else
			return false

	enabled_retrieve: ->
		ins = WorkflowManager.getInstance()
		if !ins
			return false

		if (Session.get('box') is 'outbox' or Session.get('box') is 'pending') and ins.state isnt 'draft'
			last_trace = _.last(ins.traces)
			previous_trace_id = last_trace.previous_trace_ids[0]
			previous_trace = _.find(ins.traces, (t)->
				return t._id is previous_trace_id
			)
			# 校验取回步骤的前一个步骤approve唯一并且处理人是当前用户
			previous_trace_approves = previous_trace.approves
			if previous_trace_approves.length is 1 and previous_trace_approves[0].user is Meteor.userId()
				return true
		return false

	enabled_traces: ->
		if Session.get("box") == "draft"
			return false
		else
			return true

	enabled_copy: ->
		if Session.get("box") == "draft"
			return false
		else
			return true

	instance_readonly_view_url: ->
		href = Meteor.absoluteUrl("workflow/space/"+Session.get("spaceId")+"/view/readonly/" + Session.get("instanceId"))
		ins = WorkflowManager.getInstance()
		if !ins
			return ""
		instanceName = ins.name
		return "<a href='#{href}' target='_blank'>#{instanceName}</a>"


Template.instance_button.onRendered ->
	$('[data-toggle="tooltip"]').tooltip();
	copyUrlClipboard = new Clipboard('.btn-instance-readonly-view-url-copy');

	Template.instance_button.copyUrlClipboard = copyUrlClipboard

	copyUrlClipboard.on 'success', (e) ->
		toastr.success(t("instance_readonly_view_url_copy_success"))
		e.clearSelection()

Template.instance_button.onDestroyed ->
	Template.instance_button.copyUrlClipboard.destroy();

Template.instance_button.events

	'click .btn-instance-to-print': (event)->
		if window.navigator.userAgent.toLocaleLowerCase().indexOf("chrome") < 0
				toastr.warning(TAPi18n.__("instance_chrome_print_warning"))
		else
				uobj = {}
				uobj["box"] = Session.get("box")
				uobj["X-User-Id"] = Meteor.userId()
				uobj["X-Auth-Token"] = Accounts._storedLoginToken()
				Steedos.openWindow(Steedos.absoluteUrl("workflow/space/" + Session.get("spaceId") + "/print/" + Session.get("instanceId") + "?" + $.param(uobj)))

	'click .btn-instance-update': (event)->
		InstanceManager.saveIns();
		Session.set("instance_change", false);

	'click .btn-instance-remove': (event)->
		swal {
			title: t("Are you sure?"),
			type: "warning",
			showCancelButton: true,
			cancelButtonText: t('Cancel'),
			confirmButtonColor: "#DD6B55",
			confirmButtonText: t('OK'),
			closeOnConfirm: true
		}, () ->
			Session.set("instance_change", false);
			InstanceManager.deleteIns()

	'click .btn-instance-force-end': (event)->
		swal {
			title: t("instance_cancel_title"),
			text: t("instance_cancel_reason"),
			type: "input",
			confirmButtonText: t('OK'),
			cancelButtonText: t('Cancel'),
			showCancelButton: true,
			closeOnConfirm: false
		}, (reason) ->
			# 用户选择取消
			if (reason == false)
				return false;

			if (reason == "")
				swal.showInputError(t("instance_cancel_error_reason_required"));
				return false;

			InstanceManager.terminateIns(reason);
			sweetAlert.close();

	'click .btn-instance-reassign': (event, template) ->
		Modal.show('reassign_modal')

	'click .btn-instance-relocate': (event, template) ->
		Modal.show('relocate_modal')


	'click .btn-instance-cc': (event, template) ->
		Modal.show('instance_cc_modal');

	'click .btn-instance-forward': (event, template) ->
		#判断是否为欠费工作区
		if WorkflowManager.isArrearageSpace()
			toastr.error(t("spaces_isarrearageSpace"));
			return;

		Modal.show("forward_select_flow_modal")

	'click .btn-instance-retrieve': (event, template) ->
		swal {
			title: t("instance_retrieve"),
			text: t("instance_retrieve_reason"),
			type: "input",
			confirmButtonText: t('OK'),
			cancelButtonText: t('Cancel'),
			showCancelButton: true,
			closeOnConfirm: false
		}, (reason) ->
			# 用户选择取消
			if (reason == false)
				return false;

			if (reason == "")
				swal.showInputError(t("instance_retrieve_reason"));
				return false;

			InstanceManager.retrieveIns(reason);
			sweetAlert.close();

	'click .btn-trace-list': (event, template) ->
		$(".instance").scrollTop($(".instance .instance-form").height())

	'click .btn-instance-process': (event, template)->
		# Session.set('flow_comment', $("#suggestion").val())
		Modal.show 'flow_steps_modal'
	'click .li-instance-readonly-view-url-copy': (event, template)->
		$(".btn-instance-readonly-view-url-copy").click();
