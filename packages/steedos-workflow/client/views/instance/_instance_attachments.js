InstanceAttachmentTemplate.helpers = {
	enabled_add_main_attachment: function() {
		var ins = WorkflowManager.getInstance();
		if (!ins)
			return false

		if (Session && Session.get("instancePrint"))
			return false

		// 正文最多只能有一个
		var main_attach_count = cfs.instances.find({
			'metadata.instance': ins._id,
			'metadata.current': true,
			'metadata.main': true
		}).count();

		if (main_attach_count >= 1) {
			return false;
		}


		// 开始节点并且设置了可以上传正文才显示上传正文的按钮
		var current_step = InstanceManager.getCurrentStep();
		if (current_step && current_step.step_type == "start" && current_step.can_edit_main_attach == true)
			return true

		return false
	},

	enabled_edit_normal_attachment: function() {
		var ins = WorkflowManager.getInstance();
		if (!ins)
			return false

		if (Session && Session.get("instancePrint"))
			return false

		var current_step = InstanceManager.getCurrentStep();
		if (current_step && (current_step.can_edit_normal_attach == true || current_step.can_edit_normal_attach == undefined))
			return true

		return false
	},

	main_attachment: function() {
		var instanceId = Session.get('instanceId');
		if (!instanceId)
			return;

		return cfs.instances.findOne({
			'metadata.instance': instanceId,
			'metadata.current': true,
			'metadata.main': true
		});
	},

	normal_attachments: function() {
		var instanceId = Session.get('instanceId');
		if (!instanceId)
			return;

		return cfs.instances.find({
			'metadata.instance': instanceId,
			'metadata.current': true,
			'metadata.main': {
				$ne: true
			}
		}).fetch();
	},

	showAttachments: function() {
		var ins = WorkflowManager.getInstance();
		if (!ins)
			return false;

		var instanceId = Session.get('instanceId');
		if (!instanceId)
			return false;


		var attachments = cfs.instances.find({
			'metadata.instance': instanceId,
			'metadata.current': true
		}).fetch();

		if (Session && Session.get("instancePrint") && attachments.length < 1)
			return false

		if (Session.get("box") == "draft" || Session.get("box") == "inbox" || attachments.length > 0)
			return true;
		else
			return false;
	},

	_t: function(key) {
		return TAPi18n.__(key)
	}

}

if (Meteor.isServer) {
	InstanceAttachmentTemplate.helpers._t = function(key) {
		locale = Template.instance().view.template.steedosData.locale
		return TAPi18n.__(key, {}, locale)
	}
	InstanceAttachmentTemplate.helpers.enabled_edit_main_attachment = function() {
		return false
	};
	InstanceAttachmentTemplate.helpers.enabled_edit_normal_attachment = function() {
		return false
	};

	InstanceAttachmentTemplate.helpers.main_attachment = function() {
		var instance = Template.instance().view.template.steedosData.instance;
		var attachment = cfs.instances.findOne({
			'metadata.instance': instance._id,
			'metadata.current': true,
			'metadata.main': true
		});

		return attachment;
	};

	InstanceAttachmentTemplate.helpers.normal_attachments = function() {
		var instance = Template.instance().view.template.steedosData.instance;
		var attachments = cfs.instances.find({
			'metadata.instance': instance._id,
			'metadata.current': true,
			'metadata.main': {
				$ne: true
			}
		}).fetch();

		return attachments;
	};

	InstanceAttachmentTemplate.helpers.showAttachments = function() {
		var instance = Template.instance().view.template.steedosData.instance;
		var attachments = cfs.instances.find({
			'metadata.instance': instance._id,
			'metadata.current': true
		}).fetch();

		if (attachments && attachments.length > 0) {
			return true;
		}
		return false;
	}
}