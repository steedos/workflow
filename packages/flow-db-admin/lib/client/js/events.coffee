Template.fAdminLayout.events
	'click .btn-delete': (e,t) ->
		_id = $(e.target).attr('doc')
		if Session.equals 'admin_collection_name', 'Users'
			Session.set 'admin_id', _id
			Session.set 'admin_doc', Meteor.users.findOne(_id)
		else
			Session.set 'admin_id', parseID(_id)
			Session.set 'admin_doc', adminCollectionObject(Session.get('admin_collection_name')).findOne(parseID(_id))

Template.AdminHeader.events
	'click .btn-sign-out': () ->
		Meteor.logout ->
			FlowRouter.go('/')

Template.adminDeleteWidget.events
	'click #confirm-delete': () ->
		collection = FlowRouter.getParam 'collectionName'
		_id = FlowRouter.getParam '_id'
		Meteor.call 'adminRemoveDoc', collection, _id, (error,r)->
			if error
				if error.reason
					toastr.error TAPi18n.__ error.reason
				else 
					toastr.error error

			FlowRouter.go  '/admin/view/' + collection
