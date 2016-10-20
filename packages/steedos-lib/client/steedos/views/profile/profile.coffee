Template.profile.helpers

  schema: ->
    return db.users._simpleSchema;

  user: ->
    return Meteor.user()

  userId: ->
    return Meteor.userId()

  getGravatarURL: (user, size) ->
    if Meteor.user()
      return Meteor.absoluteUrl('avatar/' + Meteor.userId());

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

  getAvatarFilePath: (avatar)->
    return '/api/files/avatars/' + avatar

  bgBodys:[{
    name:"birds",
    url:"/packages/steedos_theme/client/background/birds.jpg"
  },{
    name:"fish",
    url:"/packages/steedos_theme/client/background/fish.jpg"
  },{
    name:"books",
    url:"/packages/steedos_theme/client/background/books.jpg"
  },{
    name:"cloud",
    url:"/packages/steedos_theme/client/background/cloud.jpg"
  },{
    name:"sea",
    url:"/packages/steedos_theme/client/background/sea.jpg"
  },{
    name:"flower",
    url:"/packages/steedos_theme/client/background/flower.jpg"
  },{
    name:"beach",
    url:"/packages/steedos_theme/client/background/beach.jpg"
  }]


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
    fileObj = db.avatars.insert file
    # Inserted new doc with ID fileObj._id, and kicked off the data upload using HTTP
    Meteor.call "updateUserAvatar", fileObj._id
    setTimeout(()->
      imgURL = Meteor.absoluteUrl("avatar/" + Meteor.userId())
      $(".avatar-preview").attr("src", imgURL + "?time=" + new Date());
    ,3000)

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

  'click #bg_body a.thumbnail': (event)->
    bg = $(event.currentTarget).attr("bg")
    $("#bg_body button.btn-save-bg").attr("bg",bg)
    $("body").css("backgroundImage","url(#{bg})")
    Session.set("waiting_save_profile_bg",bg)

  'click #bg_body button.btn-save-bg': (event)->
    bg = $(event.currentTarget).attr("bg")
    accountBgBodyValue = Steedos.getAccountBgBodyValue()
    unless accountBgBodyValue
      accountBgBodyValue = {}
    accountBgBodyValue.url = bg
    Meteor.call 'setKeyValue', 'bg_body', accountBgBodyValue, (error, is_suc) ->
      if is_suc
        Session.set("waiting_save_profile_bg","")
        toastr.success t('profile_save_bg_suc')
      else
        console.error error
        toastr.error(error)

  'change #bg_body .btn-upload-bg-file .avatar-file': (event, template) ->
    oldAvatar = Steedos.getAccountBgBodyValue().avatar
    if oldAvatar
      Session.set("waiting_save_profile_bg",'/api/files/avatars/' + oldAvatar)
    file = event.target.files[0];
    fileObj = db.avatars.insert file
    fileId = fileObj._id
    bg = "/api/files/avatars/#{fileId}"
    console.log "the upload bg file url is:#{bg}"
    setTimeout(()->
      $("body").css("backgroundImage","url(#{bg})")
      Meteor.call 'setKeyValue', 'bg_body', {'url':bg,'avatar':fileId}, (error, is_suc) ->
        if is_suc
          Session.set("waiting_save_profile_bg","")
          toastr.success t('profile_save_bg_suc')
        else
          console.error error
          toastr.error(error)
    ,3000)


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
      