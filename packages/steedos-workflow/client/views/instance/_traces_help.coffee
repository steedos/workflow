TracesTemplate.helpers =
  equals: (a, b) ->
    a == b
  empty: (a) ->
    if a
      a.toString().trim().length < 1
    else
      true
  unempty: (a) ->
    if a
      a.toString().trim().length > 0
    else
      false
  append: (a, b) ->
    a + b
  dateFormat: (date) ->
    $.format.date new Date(date), formatStr
  getStepName: (stepId) ->
    step = WorkflowManager.getInstanceStep(stepId)
    if step
      return step.name
    null
  showDeleteButton: (approved) ->
    if approved and approved.type == 'cc' and approved.from_user == Meteor.userId() and approved.is_finished != true
      return true
    false
  isCC: (approved) ->
    if approved and approved.type == 'cc'
      return true
    false
  getApproveStatusIcon: (approveJudge) ->
    #已结束的显示为核准/驳回/取消申请，并显示处理状态图标
    approveStatusIcon = undefined
    switch approveJudge
      when 'approved'
        approveStatusIcon = 'ion ion-checkmark-round'
      when 'rejected'
        approveStatusIcon = 'ion ion-close-round'
      when 'terminated'
        approveStatusIcon = ''
      when 'reassigned'
        approveStatusIcon = 'ion ion-android-contact'
      when 'relocated'
        approveStatusIcon = 'ion ion-arrow-shrink'
      else
        approveStatusIcon = ''
        break
    approveStatusIcon
  getApproveStatusText: (approveJudge) ->
    #已结束的显示为核准/驳回/取消申请，并显示处理状态图标
    approveStatusText = undefined
    switch approveJudge
      when 'approved'
        approveStatusText = TAPi18n.__('Instance State approved')
      when 'rejected'
        approveStatusText = TAPi18n.__('Instance State rejected')
      when 'terminated'
        approveStatusText = TAPi18n.__('Instance State terminated')
      when 'reassigned'
        approveStatusText = TAPi18n.__('Instance State reassigned')
      when 'relocated'
        approveStatusText = TAPi18n.__('Instance State relocated')
      else
        approveStatusText = ''
        break
    approveStatusText

TracesTemplate.events = 
  'click .cc-approve-remove': (event, template) ->
    instanceId = Session.get('instanceId')
    approveId = event.target.dataset.approve
    # CALL 删除approve函数。
    InstanceManager.saveIns()
    Meteor.call 'cc_remove', instanceId, approveId, (err, result) ->
      if err
        toastr.error err
      if result == true
        WorkflowManager.callInstanceDataMethod Session.get('instanceId'), ->
          Session.set 'change_date', (new Date).getTime()
          return
      return
    return