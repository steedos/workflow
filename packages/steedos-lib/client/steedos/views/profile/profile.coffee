Template.profile.helpers

	schema: ->
		return db.users._simpleSchema;

	user: ->
		return Meteor.user()

	userId: ->
		return Meteor.userId()

	avatarURL: (avatar) ->
		if Meteor.user()
			return Steedos.absoluteUrl("avatar/#{Meteor.userId()}?w=220&h=200&fs=100&avatar=#{avatar}");

	emails: ()->
		return Meteor.user()?.emails

	more_than_one_address: ()->
		if Meteor.user()?.emails.length > 1
			return true
		return false

	isPrimary: (email)->
		isPrimary = false
		if Meteor.user()?.emails.length > 0
			Meteor.user().emails.forEach (e)->
				if e.address == email && e.primary == true
					isPrimary = true
					return

		return isPrimary

	accountBgBodyValue: ()->
		return Steedos.getAccountBgBodyValue()

	isCurrentBgUrlActive: (url)->
		return if url == Steedos.getAccountBgBodyValue().url then "active" else ""

	isCurrentBgUrlWaitingSave: (url)->
		return if url == Session.get("waiting_save_profile_bg") then "btn-warning" else "btn-default"

	bgBodys: [{
		name: "birds",
		url: "/packages/steedos_theme/client/background/birds.jpg"
	}, {
		name: "fish",
		url: "/packages/steedos_theme/client/background/fish.jpg"
	}, {
		name: "books",
		url: "/packages/steedos_theme/client/background/books.jpg"
	}, {
		name: "cloud",
		url: "/packages/steedos_theme/client/background/cloud.jpg"
	}, {
		name: "sea",
		url: "/packages/steedos_theme/client/background/sea.jpg"
	}, {
		name: "flower",
		url: "/packages/steedos_theme/client/background/flower.jpg"
	}, {
		name: "beach",
		url: "/packages/steedos_theme/client/background/beach.jpg"
	}]

	isCurrentSkinNameActive: (name)->
		return if name == Steedos.getAccountSkinValue().name then "active" else ""

	isCurrentSkinNameWaitingSave: (url)->
		return if url == Session.get("waiting_save_profile_skin_name") then "btn-warning" else "btn-default"

	isCurrentZoomNameActive: (name)->
		return if name == Steedos.getAccountZoomValue().name then "active" else ""

	isCurrentZoomNameWaitingSave: (url)->
		return if url == Session.get("waiting_save_profile_zoom_name") then "btn-warning" else "btn-default"

	skins: [{
		name: "green",
		tag: "green"
	}, {
		name: "green-light",
		tag: "green"
	}]

	zooms: ->
		return [{
			name: "normal",
			size: "1",
			title: t("zoom_title_normal")
		}, {
			name: "large",
			size: "1.2",
			title: t("zoom_title_large")
		}, {
			name: "extra-large",
			size: "1.35",
			title: t("zoom_title_extra_large")
		}]

	btn_save_i18n: () ->
		return TAPi18n.__ 'Submit'


Template.profile.onRendered ->


Template.profile.onCreated ->
	@clearForm = ->
		@find('#oldPassword').value = ''
		@find('#Password').value = ''
		@find('#confirmPassword').value = ''

	@changePassword = (callback) ->
		instance = @

		oldPassword = $('#oldPassword').val()
		Password = $('#Password').val()
		confirmPassword = $('#confirmPassword').val()

		if !oldPassword or !Password or !confirmPassword
			toastr.warning t('Old_and_new_password_required')

		else if Password == confirmPassword
			Accounts.changePassword oldPassword, Password, (error) ->
				if error
					toastr.error t('Incorrect_Password')
				else
					toastr.success t('Password_changed_successfully')
					instance.clearForm();
					if callback
						return callback()
					else
						return undefined
		else
			toastr.error t('Confirm_Password_Not_Match')


Template.profile.events

	'click .change-password': (e, t) ->
		t.changePassword()

	'change .change-avatar .avatar-file': (event, template) ->
		file = event.target.files[0];
		$("body").addClass("loading");
		db.avatars.insert file, (error, fileDoc)->
			if error
				console.error error
				toastr.error t(error.reason)
				$(document.body).removeClass('loading')
			else
# Inserted new doc with ID fileDoc._id, and kicked off the data upload using HTTP
# 理论上这里不需要加setTimeout，但是当上传图片很快成功的话，定阅到Avatar变化时可能请求不到上传成功的图片
				setTimeout(()->
					Meteor.call "updateUserAvatar", fileDoc._id, (error, result)->
						if result?.error
							$(document.body).removeClass('loading')
							toastr.error t(result.message)
						else
							$(document.body).removeClass('loading')
				, 3000)

	'click .add-email': (event, template) ->
		$(document.body).addClass("loading")
		inputValue = $('#newEmail').val()
		console.log inputValue
		Meteor.call "users_add_email", inputValue, (error, result)->
			if result?.error
				$(document.body).removeClass('loading')
				toastr.error t(result.message)
			else
				$(document.body).removeClass('loading')
				swal t("primary_email_updated"), "", "success"

	'click .fa-trash-o': (event, template)->
		email = event.target.dataset.email
		swal {
			title: t("Are you sure?"),
			type: "warning",
			showCancelButton: true,
			cancelButtonText: t('Cancel'),
			confirmButtonColor: "#DD6B55",
			confirmButtonText: t('OK'),
			closeOnConfirm: true
		}, () ->
			$(document.body).addClass("loading")
			Meteor.call "users_remove_email", email, (error, result)->
				if result?.error
					$(document.body).removeClass('loading')
					toastr.error t(result.message)
				else
					$(document.body).removeClass('loading')

	'click .send-verify-email': (event, template)->
		$(document.body).addClass("loading")
		email = event.target.dataset.email
		Meteor.call "users_verify_email", email, (error, result)->
			if result?.error
				$(document.body).removeClass('loading')
				toastr.error t(result.message)
			else
				$(document.body).removeClass('loading')
				swal t("email_verify_sent"), "", "success"

	'click .set-primary-email': (event, template)->
		$(document.body).addClass("loading")
		email = event.target.dataset.email
		Meteor.call "users_set_primary_email", email, (error, result)->
			if result?.error
				$(document.body).removeClass('loading')
				toastr.error t(result.message)
			else
				$(document.body).removeClass('loading')
				swal t("email_set_primary_success"), "", "success"

	'click #personalization .bg-body-setting a.thumbnail': (event)->
		dataset = event.currentTarget.dataset
		url = dataset.url
		accountBgBodyValue = Steedos.getAccountBgBodyValue()
		btn_save = $("#personalization button.btn-save-bg")[0]
		btn_save.dataset.url = url
		btn_save.dataset.avatar = accountBgBodyValue.avatar
		Steedos.applyAccountBgBodyValue(btn_save.dataset)
		Session.set("waiting_save_profile_bg", url)

	'click #personalization button.btn-save-bg': (event)->
		dataset = event.currentTarget.dataset
		url = dataset.url
		accountBgBodyValue = Steedos.getAccountBgBodyValue()
		unless accountBgBodyValue
			accountBgBodyValue = {}
		accountBgBodyValue.url = url
		Meteor.call 'setKeyValue', 'bg_body', accountBgBodyValue, (error, is_suc) ->
			if is_suc
				Session.set("waiting_save_profile_bg", "")
				toastr.success t('profile_save_bg_suc')
			else
				console.error error
				toastr.error(error)

	'change #personalization .btn-upload-bg-file .avatar-file': (event, template) ->
		oldAvatar = Steedos.getAccountBgBodyValue().avatar
		if oldAvatar
			Session.set("waiting_save_profile_bg", oldAvatar)
		file = event.target.files[0];
		fileObj = db.avatars.insert file
		fileId = fileObj._id
		url = fileId
		absUrl = Steedos.absoluteUrl("api/files/avatars/#{fileId}")
		console.log "the upload bg file absUrl is:#{absUrl}"
		setTimeout(()->
			Steedos.applyAccountBgBodyValue({url:url, avatar:fileId})
			Meteor.call 'setKeyValue', 'bg_body', {'url': url, 'avatar': fileId}, (error, is_suc) ->
				if is_suc
					Session.set("waiting_save_profile_bg", "")
					toastr.success t('profile_save_bg_suc')
				else
					console.error error
					toastr.error(error)
		, 3000)

	'click #personalization .skin-setting a.thumbnail': (event)->
		dataset = event.currentTarget.dataset
		skin_name = dataset.skin_name
		skin_tag = dataset.skin_tag
		btn_save = $("#personalization button.btn-save-skin")[0]
		btn_save.dataset.skin_name = skin_name
		btn_save.dataset.skin_tag = skin_tag
		$(".skin-admin-lte").removeClass().addClass("skin-admin-lte").addClass("skin-#{skin_name}")
		Session.set("waiting_save_profile_skin_name", skin_name)

	'click #personalization button.btn-save-skin': (event)->
		dataset = event.currentTarget.dataset
		skin_name = dataset.skin_name
		skin_tag = dataset.skin_tag
		accountSkinValue = Steedos.getAccountSkinValue()
		unless accountSkinValue
			accountSkinValue = {}
		accountSkinValue.name = skin_name
		accountSkinValue.tag = skin_tag
		Meteor.call 'setKeyValue', 'skin', accountSkinValue, (error, is_suc) ->
			if is_suc
				Session.set("waiting_save_profile_skin_name", "")
				toastr.success t('profile_save_skin_suc')
			else
				console.error error
				toastr.error(error)

	'click #personalization .zoom-setting a.thumbnail': (event)->
		dataset = event.currentTarget.dataset
		name = dataset.name
		size = dataset.size
		btn_save = $("#personalization button.btn-save-zoom")[0]
		btn_save.dataset.name = name
		btn_save.dataset.size = size
		Steedos.applyAccountZoomValue btn_save.dataset
		Session.set("waiting_save_profile_zoom_name", name)

	'click #personalization button.btn-save-zoom': (event)->
		dataset = event.currentTarget.dataset
		name = dataset.name
		size = dataset.size
		accountZoomValue = Steedos.getAccountZoomValue()
		unless accountZoomValue
			accountZoomValue = {}
		accountZoomValue.name = name
		accountZoomValue.size = size
		Meteor.call 'setKeyValue', 'zoom', accountZoomValue, (error, is_suc) ->
			if is_suc
				Session.set("waiting_save_profile_zoom_name", "")
				toastr.success t('profile_save_zoom_suc')
			else
				console.error error
				toastr.error(error)


Meteor.startup ->
	AutoForm.hooks
		updateProfile:
			onSuccess: (formType, result) ->
				toastr.success t('Profile_saved_successfully')
				if this.updateDoc.$set.locale != this.currentDoc.locale
					toastr.success t('Language_changed_reloading')
					setTimeout ->
						Meteor._reload.reload()
					, 1000

			onError: (formType, error) ->
				if error.reason
					toastr.error error.reason
				else
					toastr.error error
      