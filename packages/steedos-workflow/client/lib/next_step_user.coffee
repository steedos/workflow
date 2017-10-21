@NextStepUser = {}

NextStepUser.handleException = (e)->

	_fieldEmpty = (fieldname)->
		step = WorkflowManager.getInstanceStep(Session.get("next_step_id"))
		fields = WorkflowManager.getInstanceFields()
		field = fields.findPropertyByPK('_id', step[fieldname])
		if field
			$field = $("[name='" + field.code + "']")
			toastr.warning("请选择" + (field.name || field.code));
			$field.parent().addClass('has-error')
			$field.click();
		else
			console.error('_fieldEmpty', 'not find field, _id is ' + step[fieldname])

	switch e.error
		when 'applicantRole'
			if(Steedos.isSpaceAdmin(Session.get("spaceId"), Meteor.userId()))
				swal({
					title: t('not_found_user'),
					text: e.reason,
					html: true,
					showCancelButton: true,
					closeOnConfirm: false,
					confirmButtonText: t('instanc_set_applicant_role_text'),
					cancelButtonText: t('Cancel'),
					showLoaderOnConfirm: false
				}, (inputValue) ->
					if inputValue == false
						swal.close();
					else
						Steedos.openWindow(Steedos.absoluteUrl('admin/workflow/flow_roles'))
						swal({
							title: t('instance_role_set_is_complete'),
							type: "warning",
							confirmButtonText: t("OK"),
							closeOnConfirm: true
						}, ()->
							Session.set("instance_next_user_recalculate", Random.id())
							swal.close();
						)
				);
			else
				swal({
					title: t('not_found_user'),
					text: e.reason,
					html: true,
					showCancelButton: false,
					closeOnConfirm: false,
					cancelButtonText: t('Cancel')
					confirmButtonText: t('OK'),
				});

		when 'applicantSuperior'
			if Steedos.isSpaceAdmin(Session.get("spaceId"), Meteor.userId())
				swal({
					title: t('not_found_user'),
					text: e.reason,
					html: true,
					showCancelButton: true,
					closeOnConfirm: false,
					confirmButtonText: t('设置申请人上级主管'),
					cancelButtonText: t('Cancel'),
					showLoaderOnConfirm: false
				}, (inputValue) ->
					if inputValue == false
						swal.close();
					else
						Steedos.openWindow(Steedos.absoluteUrl('admin/organizations'))
						swal({
							title: t('设置完成？'),
							type: "warning",
							confirmButtonText: t("OK"),
							closeOnConfirm: true
						}, ()->
							Session.set("instance_next_user_recalculate", Random.id())
							swal.close();
						)
				);
			else
				swal({
					title: t('not_found_user'),
					text: e.reason,
					html: true,
					showCancelButton: false,
					closeOnConfirm: false,
					cancelButtonText: t('Cancel')
					confirmButtonText: t('OK'),
				});
		when 'userField'
			_fieldEmpty('approver_user_field')
		when 'orgField'
			_fieldEmpty('approver_org_field')
		when 'specifyOrg'
			if Steedos.isSpaceAdmin(Session.get("spaceId"), Meteor.userId())
				swal({
					title: t('not_found_user'),
					text: e.reason,
					html: true,
					showCancelButton: true,
					closeOnConfirm: false,
					confirmButtonText: t('设置部门成员'),
					cancelButtonText: t('Cancel'),
					showLoaderOnConfirm: false
				}, (inputValue) ->
					if inputValue == false
						swal.close();
					else
						Steedos.openWindow(Steedos.absoluteUrl('admin/organizations'))
						swal({
							title: t('设置完成？'),
							type: "warning",
							confirmButtonText: t("OK"),
							closeOnConfirm: true
						}, ()->
							Session.set("instance_next_user_recalculate", Random.id())
							swal.close();
						)
				);
			else
				swal({
					title: t('not_found_user'),
					text: e.reason,
					html: true,
					showCancelButton: false,
					closeOnConfirm: false,
					cancelButtonText: t('Cancel')
					confirmButtonText: t('OK'),
				});
		else
			throw Meteor.Error(e)
			break