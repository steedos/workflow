Template.steedos_contacts_space_user_info_modal.helpers
	spaceUserName: ->
		spaceUser = db.space_users.findOne this.targetId;
		return spaceUser.name;

	spaceUserEmail: ->
		spaceUser = db.space_users.findOne this.targetId;
		return spaceUser.email;

	spaceUserMobile: ->
		mobile = "";
		spaceUser = db.space_users.findOne this.targetId;
		if spaceUser.mobile
			mobile = spaceUser.mobile
		return mobile;
	
	spaceUserWorkPhone: ->
		workPhone = "";
		spaceUser = db.space_users.findOne this.targetId;
		if spaceUser.work_phone
			workPhone = spaceUser.work_phone
		return workPhone;
	
	spaceUserPosition: ->
		Position = "";
		spaceUser = db.space_users.findOne this.targetId;
		if spaceUser.position
			Position = spaceUser.position
		return Position;
	
	spaceUserOrganizations: ->
		spaceUser = db.space_users.findOne this.targetId;
		if spaceUser
			return SteedosDataManager.organizationRemote.find({_id: {$in: spaceUser.organizations}},{fields: {fullname: 1}})
		return []

	spaceUserInfo: ->
		info = ""
		spaceUser = db.space_users.findOne this.targetId, {fields: {name: 1, email: 1, position: 1, mobile: 1, work_phone: 1, organizations: 1}};
		if spaceUser
			orgArray = SteedosDataManager.organizationRemote.find({_id: {$in: spaceUser.organizations}},{fields: {fullname: 1}})
			if orgArray
				userInfo = {}
				orgFullname = ""
				orgArray.forEach (org)->
					orgFullname = org.fullname + ";" + orgFullname
				# 定义复制信息的样式
				userInfo[t('steedos_contacts_name')] = spaceUser.name
				userInfo[t('steedos_contacts_email')] = spaceUser.email
				userInfo[t('steedos_contacts_position')] = spaceUser.position
				userInfo[t('steedos_contacts_mobile')] = spaceUser.mobile
				userInfo[t('steedos_contacts_work_phone')] = spaceUser.work_phone
				userInfo[t('steedos_contacts_organizations')] = orgFullname
				
				info = JSON.stringify(userInfo).replace(/\{|}|"/g,'').split(',').join('\n')
		
		return info

Template.steedos_contacts_space_user_info_modal.events

	'click .steedos-info-close': (event,template) ->
		Modal.hide('steedos_contacts_space_user_info_modal')


Template.steedos_contacts_space_user_info_modal.onRendered ()->
	clipboard = new Clipboard('.steedos-info-copy', text: (spaceUser) ->
		return spaceUser.dataset.info
	)
	clipboard.on 'success', (e) ->
		console.log e
		e.clearSelection()
		toastr.success "已成功拷贝到剪贴板！"
		return
	clipboard.on 'error', (e) ->
		console.log e
		toastr.error "拷贝失败！"
		return