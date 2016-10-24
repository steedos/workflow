# Add hooks used by many forms
AutoForm.addHooks [
		'admin_insert',
		'admin_update'
		],
	beginSubmit: ->
		$('.btn-primary').addClass('disabled')
	endSubmit: ->
		$('.btn-primary').removeClass('disabled')
	onError: (formType, error)->
		# 判断错误类型
		if error.error
			AdminDashboard.alertFailure TAPi18n.__ error.reason
		else
			AdminDashboard.alertFailure TAPi18n.__ error.message


AutoForm.hooks
	admin_insert:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminInsertDoc', insertDoc, Session.get('admin_collection_name'), (e,r)->
				if e
					hook.done(e)
				else if r.e
					hook.done(r.e)
				else
					adminCallback 'onInsert', [Session.get('admin_collection_name'), insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess TAPi18n.__("flow_db_admin_successfully_created")
			FlowRouter.go "/admin/view/#{collection}"

	admin_update:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminUpdateDoc', updateDoc, Session.get('admin_collection_name'), @docId, (e,r)->
				if e
					hook.done(e)
				else if r.e
					hook.done(r.e)
				else
					adminCallback 'onUpdate', [Session.get('admin_collection_name'), insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess TAPi18n.__("flow_db_admin_successfully_updated")


	admin_modal_insert:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminInsertDoc', insertDoc, Session.get('admin_collection_name'), (e,r)->
				if e
					hook.done(e)
				else if r.e
					hook.done(r.e)
				else
					adminCallback 'onInsert', [Session.get('admin_collection_name'), insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess TAPi18n.__("flow_db_admin_successfully_created")
			Modal.hide();

	admin_modal_update:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			hook = @
			Meteor.call 'adminUpdateDoc', updateDoc, Session.get('admin_collection_name'), @docId, (e,r)->
				if e
					hook.done(e)
				else if r.e
					hook.done(r.e)
				else
					adminCallback 'onUpdate', [Session.get('admin_collection_name'), insertDoc, updateDoc, currentDoc], (collection) ->
						hook.done null, collection
			return false
		onSuccess: (formType, collection)->
			AdminDashboard.alertSuccess TAPi18n.__("flow_db_admin_successfully_updated")
			Modal.hide();
