Template.space_info.helpers

    schema: ->
        return db.spaces._simpleSchema;

    space: ->
        return db.spaces.findOne(Steedos.getSpaceId())

    btn_save_i18n: () ->
        return TAPi18n.__ 'Submit'

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
