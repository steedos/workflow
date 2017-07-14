Workflow = {}

@ImageSign = {};

@TracesTemplate = {};

@InstanceformTemplate = {};

@InstanceAttachmentTemplate = {};

@InstanceSignText = {}

@RelatedInstances = {}

@InstanceMacro = {context: {}}

@TracesManager = {};

if Meteor.isClient
	Meteor.startup ->
		if localStorage.getItem("workflow_three_columns")
			$("body").addClass("three-columns")
		else
			$("body").removeClass("three-columns")