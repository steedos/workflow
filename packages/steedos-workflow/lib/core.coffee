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
		workflow_three_columns = localStorage.getItem("workflow_three_columns")
		if workflow_three_columns and workflow_three_columns == "off"
			$("body").removeClass("three-columns")
		else
			$("body").addClass("three-columns")