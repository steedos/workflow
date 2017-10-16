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

Template.space_info.events

    'click .btn-new-space': (event)->
        FlowRouter.go("/accounts/setup/space")

    'click .btn-edit-space': (event)->
        AdminDashboard.modalEdit 'spaces', Steedos.spaceId()


    'click .btn-exit-space': (event)->



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
