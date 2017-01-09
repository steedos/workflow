Template.instance_suggestion.helpers

	equals: (a, b) ->
		return (a == b)

	includes: (a, b) ->
		return b.split(',').includes(a);

	suggestion_box_style: ->
		judge = Session.get("judge")
		if judge
			if (judge == "approved")
				return "box-success"
			else if (judge == "rejected")
				return "box-danger"

	show_toggle_button: ->
		isShow = !ApproveManager.isReadOnly() || InstanceManager.isInbox();
		if isShow
			isShow = WorkflowManager.getInstance().state != "draft"
		return isShow

	show_suggestion: ->
		return !ApproveManager.isReadOnly() || InstanceManager.isInbox();

	currentStep: ->
		return InstanceManager.getCurrentStep();

	currentApprove: ->
		approve = {}

		if !InstanceManager.isInbox()
			return approve

		instance = WorkflowManager.getInstance();

		if InstanceManager.isCC(instance)
			approve = InstanceManager.getCCApprove(Meteor.userId(), false);
		approve = InstanceManager.getCurrentApprove();
		Session.set("instance_my_approve_description", approve.description)
		return approve
	next_step_multiple: ->
		Session.get("next_step_multiple")

	next_user_multiple: ->
		Session.get("next_user_multiple")

	next_step_options: ->
		ins_applicant = Session.get("ins_applicant");
		instance_form_values = Session.get("instance_form_values")
		if instance_form_values?.instanceId == Session.get("instanceId")
			return InstanceManager.getNextStepOptions();

#next_user_options: ->
#    console.log("next_user_options run ...");
#    return InstanceManager.getNextUserOptions();

	next_user_context: ->
		instance_form_values = Session.get("instance_form_values")
		if instance_form_values?.instanceId != Session.get("instanceId")
			return {}
		console.log("next_user_context run ...");

		ins_applicant = Session.get("ins_applicant");

		next_step_id = Session.get("next_step_id");

		$("#nextStepUsers_div").show();

		if next_step_id
			nextStep = WorkflowManager.getInstanceStep(next_step_id)
			if nextStep && nextStep.step_type == 'end'
				$("#nextStepUsers_div").hide();


		form_values = instance_form_values.values
		users = InstanceManager.getNextUserOptions();

		data = {
			dataset: {},
			name: 'nextStepUsers',
			atts: {
				name: 'nextStepUsers',
				id: 'nextStepUsers',
				class: 'selectUser nextStepUsers form-control',
				style: 'padding:6px 12px;'
			}
		};

		next_user = $("input[name='nextStepUsers']");


		selectedUser = [];


		users.forEach (user) ->
			if user.selected
				selectedUser.push(user);

		if users.length == 1 && selectedUser.length < 1
			selectedUser = [users[0]];


		if next_user && next_user.length > 0

#先清空下一步处理人
			next_user[0].value = ''
			next_user[0].dataset.values = ''


			if !Session.get("next_step_users_showOrg")
				next_user[0].dataset.userOptions = users.getProperty("id")
				next_user[0].dataset.showOrg = false;
			else
				delete next_user[0].dataset.userOptions
				delete next_user[0].dataset.showOrg

			next_user[0].dataset.multiple = Session.get("next_user_multiple");

			next_userIds = []
			next_userIdObjs = []
			if next_user[0].value != ""
				next_userIds = next_user[0].dataset.values.split(",");
				next_userIdObjs = users.filterProperty("id", next_userIds)

			if next_userIds.length > 0 && next_userIdObjs.length > 0 && next_userIds.length = next_userIdObjs.length
				next_user[0].value = next_userIdObjs.getProperty("name").toString();
				next_user[0].dataset.values = next_userIdObjs.getProperty("id").toString();
				data.value = next_user[0].value;
				data.dataset['values'] = next_user[0].dataset.values;
			else
				next_user[0].value = selectedUser.getProperty("name").toString();
				next_user[0].dataset.values = selectedUser.getProperty("id").toString()
				data.value = next_user[0].value
				data.dataset['values'] = selectedUser.getProperty("id").toString()
		else
			if !Session.get("next_step_users_showOrg")
				data.dataset['userOptions'] = users.getProperty("id")
				data.dataset['showOrg'] = false;

			data.dataset['multiple'] = Session.get("next_user_multiple");

			data.value = selectedUser
			data.dataset['values'] = selectedUser.getProperty("id").toString()

		return data;

	judge: ->
		currentApprove = InstanceManager.getCurrentApprove();
		if !Session.get("judge")
			Session.set("judge", currentApprove?.judge);

		if !Session.get("judge")
			currentStep = InstanceManager.getCurrentStep();
			# 默认核准
			if (currentStep.step_type == "sign" || currentStep.step_type == "counterSign")
				Session.set("judge", "approved");

		currentApprove?.judge = Session.get("judge");

		return Session.get("judge")

	isCC: ->
		instance = WorkflowManager.getInstance();
		return InstanceManager.isCC(instance);

	enabled_submit: ->
		ins = WorkflowManager.getInstance();
		if !ins
			return "display: none;";
		flow = db.flows.findOne(ins.flow);
		if !flow
			return "display: none;";
		if InstanceManager.isInbox()
			return "";
		if !ApproveManager.isReadOnly()
			return "";
		else
			return "display: none;";

Template.instance_suggestion.events

	'change .suggestion': (event) ->
		console.log("change .suggestion");
		if ApproveManager.isReadOnly()
			return;
		judge = $("[name='judge']").filter(':checked').val();
		Session.set("next_step_id", null);
		Session.set("judge", judge);

	'change .nextSteps': (event) ->
		if event.target.name == 'nextSteps'
			if $("#nextSteps").find("option:selected").attr("steptype") == 'counterSign'
				Session.set("next_user_multiple", true)
			else
				Session.set("next_user_multiple", false)
			Session.set("next_step_id", $("#nextSteps").val())

	'click #instance_flow_opinions': (event, template)->
		Session.set('flow_comment', $("#suggestion").val())
		Modal.show 'opinion_modal'

	'input #suggestion': (event, template) ->
		if ApproveManager.isReadOnly()
			return;
		InstanceManager.checkSuggestion();
		Session.set("instance_my_approve_description", $("#suggestion").val())

	'click #instance_submit': (event)->
		if WorkflowManager.isArrearageSpace()
			ins = WorkflowManager.getInstance();
			if ins.state == "draft"
				toastr.error(t("spaces_isarrearageSpace"));
				return
		if !ApproveManager.isReadOnly()
			InstanceManager.checkFormValue();
		if($(".has-error").length == 0)
			Session.set("instance_change", false);
			InstanceManager.submitIns();
		InstanceManager.fixInstancePosition()

	'change input[name=judge]': (event)->
		if $('input[name=judge]:checked').val() == "approved"
			InstanceManager.checkSuggestion()
		InstanceManager.fixInstancePosition()

	'click .btn-suggestion-toggle,.instance-suggestion .btn-remove': (event, template)->
		$(".instance-wrapper .instance-view").toggleClass("suggestion-active")
		InstanceManager.fixInstancePosition()

Template.instance_suggestion.onCreated ->
	console.log("instance_suggestion onCreated...");

Template.instance_suggestion.onRendered ->
	console.log("instance_suggestion.onRendered...")

	currentStep = InstanceManager.getCurrentStep();
	# 当前步骤为会签时，不显示下一步步骤、处理人
	if currentStep && currentStep.step_type == 'counterSign'
		$(".instance-suggestion #instance_next").hide();


	next_step_id = Session.get("next_step_id");

	$("#nextStepUsers_div").show();

	if next_step_id
		nextStep = WorkflowManager.getInstanceStep(next_step_id)
		if nextStep && nextStep.step_type == 'end'
			$("#nextStepUsers_div").hide();
