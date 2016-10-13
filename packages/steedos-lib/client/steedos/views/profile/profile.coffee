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

  isCurrentBgUrlActive: (url)->
    return if url == Steedos.getAccountBodyBg() then "active" else ""

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
          return callback()
    else
      toastr.error t('Confirm_Password_Not_Match')

    
Template.profile.events

  'click .change-password': (e, t) ->
    t.changePassword()

  'change .avatar-file': (event, template) ->
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

  'click #bg_body button.btn-save-bg': (event)->
    bg = $(event.currentTarget).attr("bg")
    Meteor.call 'setKeyValue', 'bg_body', {'url':bg}, (error, is_suc) ->
      unless is_suc
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
        else
          FlowRouter.go("/")

      onError: (formType, error) ->
        if error.reason
          toastr.error error.reason
        else 
          toastr.error error
      