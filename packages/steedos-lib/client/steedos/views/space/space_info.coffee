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

Template.space_info.events

    'click .btn-new-space': (event)->
        swal({
            title: "请输入工作区名称", 
            text: "一个工作区就是一个工作团队，可以邀请同事、工作伙伴加入工作区，然后一起协同办公。", 
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
                    Steedos.setSpaceId(r._id)
                    toastr.success "工作区已创建成功"
        )

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
