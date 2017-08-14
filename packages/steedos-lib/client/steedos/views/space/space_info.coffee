Template.space_info.helpers

    schema: ->
        return db.spaces._simpleSchema;

    space: ->
        return db.spaces.findOne(Steedos.getSpaceId())

    btn_save_i18n: () ->
        return TAPi18n.__ 'Submit'

    spaceOwnerName: (id) ->
        user = CFDataManager.getFormulaSpaceUsers(id)
        return if user then user.name else ""

    adminsNames: (ids) ->
        return CFDataManager.getFormulaSpaceUsers(ids)?.getProperty("name").join(",")

    isDisableAddSpace: ->
        return Meteor.settings?.public?.admin?.disableAddSpace

    isRightDropdownNeeded: ->
        isSpaceAdmin = Steedos.isSpaceAdmin()
        isSpaceOwner = Steedos.isSpaceOwner()
        disableAddSpace = Meteor.settings?.public?.admin?.disableAddSpace
        unless isSpaceAdmin
            return false
        if isSpaceOwner
            return true
        return !disableAddSpace

    user_count: ->
        return Session.get('space_user_count')

Template.space_info.events

    'click .btn-new-space': (event)->
        swal({
            title: t("spaces_new_swal_title"), 
            text: t("spaces_new_swal_help"), 
            type: "input",
            confirmButtonText: t('OK'),
            cancelButtonText: t('Cancel'),
            showCancelButton: true,
            closeOnCancel: true,
            closeOnConfirm: false
        }, (name) ->
            if !name
                return false
            $("body").addClass("loading")
            Meteor.call 'adminInsertDoc', {name:name}, "spaces", (e,r)->
                $("body").removeClass("loading")
                if e
                    toastr.error e.message
                    return false

                if r && r._id
                    swal.close()
                    Steedos.setSpaceId(r._id)
                    toastr.success t("spaces_new_swal_success")
        )

    'click .btn-edit-space': (event)->
        AdminDashboard.modalEdit 'spaces', Steedos.spaceId()


    'click .btn-exit-space': (event)->


    'click #space_recharge': (event, template)->
        Modal.show('space_recharge_modal')



Meteor.startup ->

    AutoForm.hooks

        updateSpace:
            
            onSuccess: (formType, result) ->
                toastr.success t('saved_successfully')

            onError: (formType, error) ->
                if error.reason
                    toastr.error error.reason
                else 
                    toastr.error error


Template.space_info.onRendered ()->
    that = this
    if Session.get('spaceId')
        Meteor.call 'get_space_user_count', Session.get('spaceId'), (err, result)->
            if err
                console.log err.reason
            if result
                Session.set('space_user_count',result)
