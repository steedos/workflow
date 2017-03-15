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
        return CFDataManager.getFormulaSpaceUsers(ids).getProperty("name").join(",")

Template.space_info.events

    'click .btn-new-space': (event)->
        swal({
          title: "请输入工作区名称", 
          text: "", 
          type: "input",
          showCancelButton: true,
          closeOnCancel: true,
          closeOnConfirm: false,
          showLoaderOnConfirm: true
        }, (name) ->
          if !name
            return false

          Meteor.call 'adminInsertDoc', {name:name}, "spaces", (e,r)->
            if e
              swal("Error", e, "error")
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
