Template.steedos_contacts_space_user_info_modal.helpers
	isMobile: ->
		return Steedos.isMobile()

	spaceUser: ->
		return db.space_users.findOne this.targetId;
	
	spaceUserOrganizations: ->
		spaceUser = db.space_users.findOne this.targetId;
		if spaceUser
			if Steedos.isMobile()
				return SteedosDataManager.organizationRemote.find({_id: {$in: spaceUser.organizations}},{fields: {name: 1}})
			else
				return SteedosDataManager.organizationRemote.find({_id: {$in: spaceUser.organizations}},{fields: {fullname: 1}})
		return []

	isPrimaryOrg: (id)->
		spaceUser = db.space_users.findOne Template.instance().data.targetId;
		return spaceUser?.organization == id

	spaceUserInfo: ->
		info = ""
		spaceUser = db.space_users.findOne this.targetId, {fields: {name: 1, email: 1, position: 1, mobile: 1, work_phone: 1, organizations: 1}};
		if spaceUser
			orgArray = SteedosDataManager.organizationRemote.find({_id: {$in: spaceUser.organizations}},{fields: {fullname: 1}})
			if orgArray
				userInfo = []
				orgFullname = ""
				orgArray.forEach (org)->
					orgFullname = org.fullname + "\r\n               " + orgFullname
				# 定义复制信息的样式
				userInfo.push("#{t('steedos_contacts_name')}:#{spaceUser.name}")
				userInfo.push("#{t('steedos_contacts_email')}:#{if spaceUser.email then spaceUser.email else ""}")
				userInfo.push("#{t('steedos_contacts_position')}:#{if spaceUser.position then spaceUser.position else ""}")
				userInfo.push("#{t('steedos_contacts_mobile')}:#{if spaceUser.mobile then spaceUser.mobile else ""}")
				userInfo.push("#{t('steedos_contacts_work_phone')}:#{if spaceUser.work_phone then spaceUser.work_phone else ""}")
				userInfo.push("#{t('steedos_contacts_organizations')}:#{orgFullname}")
				
				info = userInfo.join('\n')
		
		return info

	isEditable: ->
		if Template.instance().data.isEditable == false
			return false;

		if Steedos.isSpaceAdmin() || (Session.get('contacts_is_org_admin') && !Session.get("contact_list_search"))
			return true
		else
			return false

	username: () ->
		 return Template.instance().username?.get()


Template.steedos_contacts_space_user_info_modal.events
	'click .steedos-info-close': (event,template) ->
		$("#steedos_contacts_space_user_info_modal .close").trigger("click")

	'click .steedos-info-edit': (event, template) ->
		unless Steedos.isPaidSpace()
			$("body").on("click",".admin-dashboard-body input[name=mobile]",()->
				swal({title: t("steedos_contacts_mobile_edit_power")})
			)
		AdminDashboard.modalEdit 'space_users', event.currentTarget.dataset.id, ->
			$("body").off("click",".admin-dashboard-body input[name=mobile]")

	'click .btn-edit-username': (event, template) ->
		username = template.username?.get()
		user_id = event.currentTarget.dataset.id
		unless user_id
			return;
		swal {
			title: t('Change username')
			type: "input"
			inputValue: username || ""
			showCancelButton: true
			closeOnConfirm: false
			confirmButtonText: t('OK')
			cancelButtonText: t('Cancel')
			showLoaderOnConfirm: false
		}, (inputValue)->
			if inputValue is false
				return false
			if inputValue?.trim() == username?.trim()
				swal.close()
				return false;
			Meteor.call "setUsername", inputValue?.trim(), user_id, (error, results)->
				if results
					template.username.set(results);
					toastr.success t('Change username successfully')
					swal.close()
				if error
					toastr.error(TAPi18n.__(error.error))

	'click .steedos-info-delete': (event, template) ->
		AdminDashboard.modalDelete 'space_users', event.currentTarget.dataset.id, ->
			$("#steedos_contacts_space_user_info_modal .close").trigger("click")

	'click .btn-set-primary': (event, template) ->
		$("body").addClass("loading")
		spaceUserId = template.data.targetId
		orgId = event.currentTarget.dataset.id
		Meteor.call "set_primary_org", orgId, spaceUserId, (error, results)->
			$("body").removeClass("loading")
			if error
				toastr.error(TAPi18n.__(error.reason))



Template.steedos_contacts_space_user_info_modal.onRendered ()->
	copyInfoClipboard = new Clipboard('.steedos-info-copy', text: (spaceUser) ->
		return spaceUser.dataset.info
	)

	Template.steedos_contacts_space_user_info_modal.copyInfoClipboard = copyInfoClipboard
	
	copyInfoClipboard.on 'success', (e) ->
		e.clearSelection()
		toastr.success t("steedos_contacts_copy_successfully")
		return
	copyInfoClipboard.on 'error', (e) ->
		toastr.error t("steedos_contacts_copy_failed")
		return
	$("#steedos_contacts_space_user_info_modal .weui-modal-content").css("max-height", Steedos.getModalMaxHeight(30));

Template.steedos_contacts_space_user_info_modal.onDestroyed ->
	Modal.allowMultiple = false
	Template.steedos_contacts_space_user_info_modal.copyInfoClipboard.destroy()


Template.steedos_contacts_space_user_info_modal.onCreated ->
	self = this
	self.username = new ReactiveVar("")
	space_user = db.space_users.findOne Template.instance().data.targetId
	$("body").addClass("loading")
	Meteor.call 'fetchUsername', space_user.user, (error, result) ->
		$("body").removeClass("loading")
		if error
			toastr.error TAPi18n.__(error.reason)
		else
			self.username.set(result)
