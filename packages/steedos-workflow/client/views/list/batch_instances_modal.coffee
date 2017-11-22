Template.batch_instances_modal.onCreated ()->
	that = this

	that.batch_instances = new ReactiveVar()

	that.submitted = new ReactiveVar(new Array())

	that.progress = 0

	categoryId = Session.get("workflowCategory")
	if Session.get("flowId")
		flows = [Session.get("flowId")]

	Meteor.call 'get_batch_instances', Session.get("spaceId"), categoryId, flows, (error, result)->
		if error
			toastr.error 'error'
		else

			console.log(result)

			that.batch_instances.set(result)

Template.batch_instances_modal.helpers
	batch_instances: ()->
		return {batch_instances: Template.instance().batch_instances.get(), submitted: Template.instance().submitted.get()}

	batch_instances_length: ()->
		return Template.instance().batch_instances.get()?.length || 0

	submitted: ()->
		return Template.instance().submitted.get()?.length

	progress: ()->
		return parseInt(Template.instance().submitted.get()?.length / Template.instance().batch_instances.get()?.length * 100)


Template.batch_instances_modal.events

	'click .confirm': (event, template)->
		console.log("template.batch_instances.get()", template.batch_instances.get())

		description = $("#batch_instances_description").val() || ''

		time1 = new Date().getTime()

		Meteor.call 'get_my_approves', template.batch_instances.get().getProperty("_id"), (error, result)->
			time2 = new Date().getTime()
			console.log("get_my_approves", time2 - time1)
			if error
				toastr.error 'error'
			else
				console.log("result", result)
#				instanceBatch.submit result
				result.forEach (approve)->
					approve.description = description
					instanceBatch.submit [approve], ()->
						submitted = template.submitted.get()
						submitted.push(approve.instance)
						template.submitted.set(submitted)
						time3 = new Date().getTime()
						console.log("instanceBatch", time3 - time1)
