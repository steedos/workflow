Template.space_info.helpers

    schema: ->
        return db.spaces._simpleSchema;

    space: ->
        return db.spaces.findOne(Steedos.getSpaceId())



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
