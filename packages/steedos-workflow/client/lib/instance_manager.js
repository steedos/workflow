InstanceManager = {};

InstanceManager.runFormula = function(fieldCode) {
  console.log("InstanceManager.runFormula...");
  var form_version = WorkflowManager.getInstanceFormVersion();
  var formula_fields = []
  if (form_version)
    formula_fields = Form_formula.getFormulaFieldVariable("Form_formula.field_values", form_version.fields);

  Form_formula.run(fieldCode, "", formula_fields, AutoForm.getFormValues("instanceform").insertDoc, form_version.fields);

  Session.set("form_values", AutoForm.getFormValues("instanceform").insertDoc);
}


InstanceManager.getFormField = function(fieldId) {
  var instanceFields = WorkflowManager.getInstanceFields();
  var field = instanceFields.filterProperty("_id", fieldId);

  if (field.length > 0) {
    return field[0];
  }

  return null;
}


InstanceManager.getNextStepOptions = function() {

  console.log("calculate next_step_options")
  if (ApproveManager.isReadOnly())
    return []

  var instance = WorkflowManager.getInstance();
  var currentApprove = InstanceManager.getCurrentApprove();
  var current_next_steps;
  if (currentApprove) {
    current_next_steps = currentApprove.next_steps;
  }
  var judge = Session.get("judge");
  var currentStep = InstanceManager.getCurrentStep();
  var form_version = WorkflowManager.getInstanceFormVersion();
  // 待办：获取表单值
  var autoFormDoc = {};
  if (AutoForm.getFormValues("instanceform")) {
    autoFormDoc = AutoForm.getFormValues("instanceform").insertDoc;
  } else if (Session.get("form_values")) {
    autoFormDoc = Session.get("form_values")
  }

  var nextSteps = ApproveManager.getNextSteps(instance, currentStep, judge, autoFormDoc, form_version.fields);

  var next_step_options = []
  if (nextSteps && nextSteps.length > 0) {
    var next_step_id = Session.get("next_step_id");
    var next_step_type = null;
    nextSteps.forEach(function(step) {
      var option = {
        id: step.id,
        text: step.name,
        type: step.step_type
      }
      if (!next_step_id && current_next_steps && current_next_steps.length > 0) {
        if (current_next_steps[0].step == step.id) {
          next_step_id = step.id
        }
      }
      next_step_options.push(option)
    });

    // 默认选中第一个
    if (next_step_options.length == 1) {

      next_step_options[0].selected = true
      next_step_id = next_step_options[0].id

    } else {

      if (!next_step_id && Session.get("judge") == 'rejected') {
        start_option = next_step_options.findPropertyByPK("type", "start");
        next_step_id = start_option.id
      } else if (Session.get("judge") != 'rejected') {
        next_step_options.unshift({
          id: '',
          selected: true,
          text: TAPi18n.__("Select placeholder"),
          disabled: 'disabled'
        });
      }

    }

    Session.set("next_step_id", next_step_id);

    next_step_options.forEach(function(option) {
      if (option.id == next_step_id) {
        option.selected = true
        next_step_type = option.type
      }
    });

    //触发select重新加载
    Session.set("next_step_multiple", false)
    if (next_step_id) {
      if (next_step_type == 'counterSign')
        Session.set("next_user_multiple", true)
      else
        Session.set("next_user_multiple", false)
    }
  } else {
    Session.set("next_step_id", null);
  }
  return next_step_options;
}

// InstanceManager.updateNextStepTagOptions = function(){
//   var next_step_options = InstanceManager.getNextStepOptions();
//   $("#nextSteps").empty(); // 清空选项
//   next_step_options.forEach(function(next_step_option){
//     $("#nextSteps").append("<option value='" + next_step_option.id + "'>" + next_step_option.text + "</option>");
//     if(next_step_option.selected){
//       $("#nextSteps").val(next_step_option.id);
//     }
//   });
// }

InstanceManager.getNextUserOptions = function() {
  console.log("calculate next_user_options")

  var next_user_options = []

  var next_step_id = Session.get("next_step_id");
  var next_user_multiple = Session.get("next_user_multiple")
  if (next_step_id) {

    var instance = WorkflowManager.getInstance();
    var currentApprove = InstanceManager.getCurrentApprove();
    var current_next_steps = currentApprove.next_steps;

    var next_user_ids = [];
    var nextStepUsers = ApproveManager.getNextStepUsers(instance, next_step_id);
    if (nextStepUsers) {
      nextStepUsers.forEach(function(user) {
        var option = {
          id: user.id,
          name: user.name
        }
        if (current_next_steps && current_next_steps.length > 0) {
          if (current_next_steps[0].step == next_step_id && _.contains(current_next_steps[0].users, user.id)) {
            option.selected = true
            next_user_ids.push(user.id)
          }
        }
        next_user_options.push(option)
      });

    }
    //if ( next_user_options.length > 0){ //==1
    //    next_user_options[0].selected = true
    //    next_user_ids.push(next_user_options[0].id)
    //}
  }

  return next_user_options;
}

// InstanceManager.updateNextUserTagOptions = function(){
//   var next_user_options = InstanceManager.getNextUserOptions();
//   $("#nextStepUsers").empty(); // 清空选项
//   next_user_options.forEach(function(next_user_option){
//     $("#nextStepUsers").append("<option value='" + next_user_option.id + "' >" + next_user_option.text + "</option>");
//     if(next_user_option.selected){
//       $("#nextStepUsers").val(next_user_option.id);
//     }
//   });
// }


InstanceManager.getFormFieldByCode = function(fieldCode) {
  var instanceFields = WorkflowManager.getInstanceFields();
  var field = instanceFields.filterProperty("code", fieldCode);

  if (field.length > 0) {
    return field[0];
  }

  return null;
}

InstanceManager.getApplicantUserId = function() {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    var ins_applicant = $("#ins_applicant");
    if (instance.state == 'draft' && ins_applicant && ins_applicant.length == 1 && ins_applicant[0] && ins_applicant[0].dataset.values) {
      return ins_applicant[0].dataset.values;
    } else {
      return instance.applicant;
    }
    return '';
  }
}

function showMessage(parent_group, message) {
  parent_group.addClass("has-error");
  $(".help-block", parent_group).html(message);
  if (message && message.length > 0) {
    toastr.error(message);
  }
}

function removeMessage(parent_group) {
  parent_group.removeClass("has-error");
  $(".help-block", parent_group).html('');
}

InstanceManager.checkFormValue = function() {

  InstanceManager.checkNextStep();

  InstanceManager.checkNextStepUser();

  InstanceManager.checkSuggestion();

  //字段校验
  var fieldsPermision = WorkflowManager.getInstanceFieldPermission();

  for (var k in fieldsPermision) {
    if (fieldsPermision[k] == 'editable') {
      InstanceManager.checkFormFieldValue($("[name='" + k + "']")[0]);
    }
  }
}

//下一步步骤校验
InstanceManager.checkNextStep = function() {
  var nextSteps_parent_group = $("#nextSteps").parent();

  if (ApproveManager.error.nextSteps != '') {
    showMessage(nextSteps_parent_group, ApproveManager.error.nextSteps);
    ApproveManager.error.nextSteps = '';
    return;
  }

  var value = ApproveManager.getNextStepsSelectValue();
  if (value && value != '-1')
    removeMessage(nextSteps_parent_group);
  else
    showMessage(nextSteps_parent_group, TAPi18n.__("instance_select_next_step"));
}

//下一步处理人校验
InstanceManager.checkNextStepUser = function() {
  var nextStepUsers_parent_group = $("#nextStepUsers").parent();

  if (ApproveManager.error.nextStepUsers != '') {
    showMessage(nextStepUsers_parent_group, ApproveManager.error.nextStepUsers);
    ApproveManager.error.nextStepUsers = '';
    return;
  }
  var value = ApproveManager.getNextStepUsersSelectValue();
  var nextStepId = ApproveManager.getNextStepsSelectValue();
  var nextStep = WorkflowManager.getInstanceStep(nextStepId);

  if (value.length > 0 || (nextStep && nextStep.step_type == 'end'))
    removeMessage(nextStepUsers_parent_group);
  else
    showMessage(nextStepUsers_parent_group, TAPi18n.__("instance_next_step_user"));
}

//如果是驳回必须填写意见
InstanceManager.checkSuggestion = function() {
  var judge = $("[name='judge']").filter(':checked').val();
  var suggestion_parent_group = $("#suggestion").parent();
  if (judge && judge == 'rejected') {
    if ($("#suggestion").val())
      removeMessage(suggestion_parent_group);
    else
      showMessage(suggestion_parent_group, TAPi18n.__("instance_reasons_reject"));
  } else {
    removeMessage(suggestion_parent_group);
  }
}

InstanceManager.checkFormFieldValue = function(field) {

  if (!field)
    return;

  var reg_email = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
  var parent_group = $("#" + field.id).parent();
  var message = '';

  var jquery_f = $("[name='" + field.dataset.schemaKey + "']");

  if (jquery_f.attr("type") != 'table' && field.parentNode.dataset.required == "true" || ((field.type == "checkbox" || field.type == "radio") && field.parentNode.parentNode.parentNode.dataset.required == "true")) {
    var fileValue = "";
    if (field.type == "checkbox" || field.type == "radio") {
      fileValue = $("[name='" + field.name + "']:checked").val();
    } else {
      fileValue = field.value;
    }

    if (!fileValue || fileValue == '' || fileValue.length < 1) {
      var fo = InstanceManager.getFormFieldByCode(field.name);
      var titleName = field.name
      if (fo) {
        titleName = fo.name ? fo.name : fo.code;
      }
      message = showMessage(parent_group, TAPi18n.__("instance_field") + "‘" + titleName + '’' + TAPi18n.__("instance_is_required"));
    }
  }

  if (jquery_f.attr("type") == 'table' && field.parentNode.parentNode.parentNode.parentNode.dataset.required == "true") {
    var table_value = AutoForm.getFieldValue(field.dataset.schemaKey, "instanceform");
    parent_group = jquery_f.parent().parent().parent().parent();
    if (!table_value || table_value.length < 1) {
      debugger;
      message = showMessage(parent_group, TAPi18n.__("instance_field") + "‘" + field.dataset.label + '’' + TAPi18n.__("instance_is_required"));
    }
  }

  if (field.type == 'email' && field.value != '') {
    if (!reg_email.test(field.value))
      message = TAPi18n.__("instance_email_format_error");
  }

  if (message == '') {
    removeMessage(parent_group);
    return true;
  } else {
    showMessage(parent_group, message);
    return false;
  }
}

InstanceManager.getFormFieldValue = function(fieldCode) {
  return AutoForm.getFieldValue(fieldCode, "instanceform");
}

function adjustFieldValue(field, value) {
  if (!value && value != false) {
    return value;
  }
  var adjustFieldTypes = ['number', 'multiSelect', 'radio', 'checkbox', 'dateTime', 'user', 'group'];

  if (adjustFieldTypes.includes(field.type)) {
    switch (field.type) {
      case 'number':
        value = value.toString();
        break;
      case 'multiSelect':
        value = value.toString();
        break;
      case 'radio':
        value = value.toString();
        break;
      case 'checkbox':
        value = value.toString();
        break;
      case 'dateTime':
        value = value; //$.format.date(value,"yyyy-MM-ddTHH:mm'Z");
        break;
      case 'group':
        value = CFDataManager.getFormulaOrganizations(value);
        break;
      case 'user':
        value = WorkflowManager.getFormulaUserObjects(value);
        break;
    }
  }
  return value;
}


InstanceManager.getInstanceValuesByAutoForm = function() {

  var fields = WorkflowManager.getInstanceFields();

  var instanceValue = InstanceManager.getCurrentValues();
  var autoFormValue = AutoForm.getFormValues("instanceform").insertDoc;

  var values = {};

  fields.forEach(function(field) {
    if (field.type == 'table') {
      t_values = new Array();
      if (field.sfields) {
        if (!autoFormValue[field.code])
          return;
        autoFormValue[field.code].forEach(function(t_row_value) {
          field.sfields.forEach(function(sfield) {
            //if(sfield.type == 'checkbox'){
            t_row_value[sfield.code] = adjustFieldValue(sfield, t_row_value[sfield.code]);
            //}
          });
          t_values.push(t_row_value);
        });
      }
      values[field.code] = t_values;
    } else {
      if (field.type != 'section') {
        values[field.code] = adjustFieldValue(field, autoFormValue[field.code]);
      }
    }
  });

  return values;
}

InstanceManager.resetId = function(instance) {
  if (instance._id) {
    instance.id = instance._id;
    delete instance._id;
  }
  instance.traces.forEach(function(t) {
    if (t._id) {
      t.id = t._id;
      delete t._id;
    }
    if (t.approves) {
      t.approves.forEach(function(a) {
        if (a._id) {
          a.id = a._id;
          delete a._id;
        }
      })
    }
  })
}

InstanceManager.getCurrentStep = function() {

  var instance = WorkflowManager.getInstance();

  if (!instance || !instance.traces)
    return;

  var currentTrace = instance.traces[instance.traces.length - 1];

  var currentStepId = currentTrace.step;

  return WorkflowManager.getInstanceStep(currentStepId);
}

InstanceManager.getCurrentValues = function() {
  var box = Session.get("box"),
    instanceValue;

  var instance = WorkflowManager.getInstance();

  if (InstanceManager.isCC(instance)) {

    instanceValue = instance.values;

  } else {

    if (box == "draft") {
      approve = InstanceManager.getCurrentApprove();
      if (approve && approve.values)
        return approve.values
    } else if (box == "inbox") {
      approve = InstanceManager.getCurrentApprove();
      if (approve && approve.values) {
        if (_.isEmpty(approve.values))
          approve.values = InstanceManager.clone(WorkflowManager.getInstance().values)
        return approve.values
      }
    } else if (box == "outbox" || box == "pending" || box == "completed" || box == "monitor") {

      instanceValue = instance.values;
    }

  }
  return instanceValue;
}

InstanceManager.clone = function(obj) {
  if (!obj) {
    return
  }
  return JSON.parse(JSON.stringify(obj))
}

InstanceManager.getCurrentApprove = function() {
  var instance = WorkflowManager.getInstance();

  if (!instance)
    return;

  if (!instance.traces || instance.traces.length < 1)
    return;

  var currentTraces = instance.traces.filterProperty("is_finished", false);

  if (currentTraces.length < 1)
    return;

  var currentApproves = currentTraces[0].approves.filterProperty("is_finished", false).filterProperty("handler", Meteor.userId());

  var currentApprove = currentApproves.length > 0 ? currentApproves[0] : null;

  if (!currentApprove)
    return;

  if (currentApprove._id) {
    currentApprove.id = currentApprove._id;
  }

  return currentApprove;
}

InstanceManager.getMyApprove = function() {

  var currentApprove = InstanceManager.getCurrentApprove();

  if (currentApprove) {
    currentApprove.description = $("#suggestion").val();
    var judge = $("[name='judge']").filter(':checked').val();
    if (judge)
      currentApprove.judge = judge;
    var nextStepId = ApproveManager.getNextStepsSelectValue();
    if (nextStepId) {

      var selectedNextStepUsers = ApproveManager.getNextStepUsersSelectValue();
      var nextStepUsers = new Array();
      if (selectedNextStepUsers instanceof Array) {
        selectedNextStepUsers.forEach(function(su) {
          nextStepUsers.push(su);
        });
      } else if (selectedNextStepUsers) {
        nextStepUsers.push(selectedNextStepUsers);
      }

      currentApprove.next_steps = [{
        step: nextStepId,
        users: nextStepUsers
      }];
    }

    currentApprove.values = InstanceManager.getInstanceValuesByAutoForm();

    return currentApprove;
  }

  return {};
}

// 申请单暂存
InstanceManager.saveIns = function() {

  //如果instanceform不存在，则不执行暂存操作
  if (!AutoForm.getFormValues("instanceform"))
    return

  var instance = WorkflowManager.getInstance();
  if (instance) {
    if (InstanceManager.isCC(instance)) {
      var description = $("#suggestion").val();
      Meteor.call('cc_save', instance._id, description, function(error, result) {
        if (error) {
          toastr.error(error);
        };
        if (result == true) {
          WorkflowManager.instanceModified.set(false)
          toastr.success(TAPi18n.__('Saved successfully'));
        }
      })
    } else {
      var state = instance.state;
      if (state == "draft") {
        instance.traces[0].approves[0] = InstanceManager.getMyApprove();
        var selected_applicant = $("input[name='ins_applicant']")[0].dataset.values;
        if (instance.applicant != selected_applicant) {
          var space_id = instance.space;
          
          var applicant = SteedosDataManager.spaceUserRemote.findOne({
            space: space_id,
            user: selected_applicant
          }, {
            fields: {
              organization: 1,
              name: 1
            }
          });
          var org_id = applicant.organization;
          var organization = SteedosDataManager.organizationRemote.findOne(org_id, {
            fields: {
              name: 1,
              fullname: 1
            }
          });

          instance.applicant = selected_applicant;
          instance.applicant_name = applicant.name;
          instance.applicant_organization = org_id;
          instance.applicant_organization_name = organization.name;
          instance.applicant_organization_fullname = organization.fullname;
        }
        Meteor.call("draft_save_instance", instance, function(error, result) {
          WorkflowManager.instanceModified.set(false)
          if (result == true) {
            toastr.success(TAPi18n.__('Saved successfully'));
          } else if (result == "upgraded") {
            toastr.info(TAPi18n.__('Flow upgraded'));
            FlowRouter.go("/workflow/space/" + Session.get('spaceId') + "/draft/");
          } else {
            toastr.error(error);
          }

        });
      } else if (state == "pending") {
        var myApprove = InstanceManager.getMyApprove();
        myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
        if (instance.attachments && myApprove) {
          myApprove.attachments = instance.attachments;
        }
        Meteor.call("inbox_save_instance", myApprove, function(error, result) {
          WorkflowManager.instanceModified.set(false)
          if (result == true)
            toastr.success(TAPi18n.__('Saved successfully'));
          else
            toastr.error(error);
        });
      }
    }
  }
}

// 申请单新建
InstanceManager.newIns = function(flowId) {
  UUflow_api.post_draft(flowId);
}

// 申请单删除
InstanceManager.deleteIns = function() {
  var instance = WorkflowManager.getInstance();
  if (!instance)
    return;
  // 删除附件
  var attachs = cfs.instances.find({
    "metadata.instance": instance._id
  });
  attachs.forEach(function(a) {
    a.remove();
  })
  UUflow_api.delete_draft(instance._id);
}

// 申请单提交
InstanceManager.submitIns = function() {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    if (InstanceManager.isCC(instance)) {
      var description = $("#suggestion").val();
      Meteor.call('cc_submit', instance._id, description, function(error, result) {
        if (error) {
          toastr.error(error);
        };

        if (result == true) {
          WorkflowManager.instanceModified.set(false);
          toastr.success(TAPi18n.__('Submitted successfully'));
          FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box"));
        };
      });
    } else {
      InstanceManager.resetId(instance);
      var state = instance.state;
      if (state == "draft") {

        var selected_applicant = $("input[name='ins_applicant']")[0].dataset.values;
        if (instance.applicant != selected_applicant) {
          var space_id = instance.space;
          var applicant = SteedosDataManager.spaceUserRemote.findOne({
            space: space_id,
            user: selected_applicant
          }, {
            fields: {
              organization: 1,
              name: 1
            }
          });
          var org_id = applicant.organization;
          var organization = SteedosDataManager.organizationRemote.findOne(org_id, {
            fields: {
              name: 1,
              fullname: 1
            }
          });

          instance.applicant = selected_applicant;
          instance.applicant_name = applicant.name;
          instance.applicant_organization = org_id;
          instance.applicant_organization_name = organization.name;
          instance.applicant_organization_fullname = organization.fullname;
        }

        instance.traces[0].approves[0] = InstanceManager.getMyApprove();
        UUflow_api.post_submit(instance);
      } else if (state == "pending") {
        var myApprove = InstanceManager.getMyApprove();
        if (instance.attachments && myApprove) {
          myApprove.attachments = instance.attachments;
        }
        myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
        UUflow_api.post_engine(myApprove);
      }
    }
  }
}

// 取消申请
InstanceManager.terminateIns = function(reason) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    instance.terminate_reason = reason;
    UUflow_api.post_terminate(instance);
  }
}

// 导出报表
InstanceManager.exportIns = function(type) {
  spaceId = Session.get("spaceId");
  flowId = Session.get("flowId");
  if (spaceId && flowId)
    UUflow_api.get_export(spaceId, flowId, type);
}

// 转签核
InstanceManager.reassignIns = function(user_ids, reason) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    instance.inbox_users = user_ids;
    instance.reassign_reason = reason;
    UUflow_api.put_reassign(instance);
  }
}

// 转签核
InstanceManager.relocateIns = function(step_id, user_ids, reason) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    InstanceManager.resetId(instance);
    instance.relocate_next_step = step_id;
    instance.relocate_inbox_users = user_ids;
    instance.relocate_comment = reason;
    UUflow_api.put_relocate(instance);
  }
}

// 归档
InstanceManager.archiveIns = function(insId) {
  var instance = WorkflowManager.getInstance();
  if (instance) {
    if (instance.is_archived == true)
      return;
    UUflow_api.post_archive(insId);
  }
}

// 添加附件
InstanceManager.addAttach = function(fileObj, isAddVersion) {
  console.log("InstanceManager.addAttach");
  var instance = WorkflowManager.getInstance();
  if (instance) {
    var state = instance.state;

    var curTime = new Date();
    var userId = Meteor.userId();
    var fileName = fileObj.name;
    console.log(fileName);
    if (!fileName)
      fileName = Session.get('filename');


    console.log(fileName);

    var attachs = instance.attachments || [];
    var hasRepeatedFile = false;
    var attach_id = Session.get("attach_id");
    attachs.forEach(function(a) {
      if (a.filename == fileName || (isAddVersion == true && a._id == attach_id)) {
        hasRepeatedFile = true;
        var his = a.historys;
        if (!(his instanceof Array))
          his = [];

        var my_approve_id = InstanceManager.getMyApprove().id;
        if (a.current.approve != my_approve_id) {
          his.unshift(a.current);
        }

        a.historys = his;
        a.current = {
          "_id": Meteor.uuid(),
          "_rev": fileObj._id,
          "length": fileObj.size,
          "approve": my_approve_id,
          "created": curTime,
          "created_by": userId,
          "created_by_name": Meteor.user().name,
          "filename": fileName
        };
        a.filename = fileName;
      }
    })

    if (!hasRepeatedFile) {
      var attach = {
        "_id": Meteor.uuid(),
        "filename": fileName,
        "contentType": fileObj.type,
        "modified": curTime,
        "modified_by": userId,
        "created": curTime,
        "created_by": userId,
        "current": {
          "_id": Meteor.uuid(),
          "_rev": fileObj._id,
          "length": fileObj.size,
          "approve": InstanceManager.getMyApprove().id,
          "created": curTime,
          "created_by": userId,
          "created_by_name": Meteor.user().name,
          "filename": fileName
        }
      };
      if (attachs) {
        attachs.push(attach);
      } else {
        attachs = [attach];
      }
    }
    WorkflowManager.instanceModified.set(true);

    if (state == "draft") {
      instance.attachments = attachs;
      instance.traces[0].approves[0] = InstanceManager.getMyApprove();
      Meteor.call("draft_save_instance", instance, function(error, result) {
        Session.set('change_date', new Date());
        WorkflowManager.instanceModified.set(false);
        if (result == true) {

          toastr.success(TAPi18n.__('Attachment was added successfully'));
        } else {
          toastr.error(error);
        }
      });
    } else if (state == "pending") {
      var myApprove = {};
      $.extend(myApprove, InstanceManager.getMyApprove());
      myApprove.attachments = attachs;
      myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
      Meteor.call("inbox_save_instance", myApprove, function(error, result) {
        Session.set('change_date', new Date());
        WorkflowManager.instanceModified.set(false);
        if (result == true) {

          toastr.success(TAPi18n.__('Attachment was added successfully'));
        } else {
          toastr.error(error);
        }
      });
    }
  }
}

// 移除附件
InstanceManager.removeAttach = function() {
  console.log("InstanceManager.removeAttach");
  var instance = WorkflowManager.getInstance();
  if (instance) {
    var state = instance.state;
    var attachs = instance.attachments;
    var file_id = Session.get("file_id");
    var newAttachs = attachs.filter(function(item) {
      if (item.current._rev != file_id) {
        return item;
      } else {
        var his = item.historys;
        if (his && his.length > 0) {
          item.current = item.historys.shift();
          item.filename = item.current.filename;
          return item;
        }
      }
    })
    WorkflowManager.instanceModified.set(true);

    if (state == "draft") {
      instance.attachments = newAttachs;
      instance.traces[0].approves[0] = InstanceManager.getMyApprove();
      Meteor.call("draft_save_instance", instance, function(error, result) {
        Session.set('change_date', new Date());
        WorkflowManager.instanceModified.set(false);
        if (result == true) {

          toastr.success(TAPi18n.__('Attachment deleted successfully'));
        } else {
          toastr.error(error);
        }
      });
    } else if (state == "pending") {
      instance.attachments = newAttachs;
      var myApprove = {};
      $.extend(myApprove, InstanceManager.getMyApprove());
      myApprove.attachments = newAttachs;
      myApprove.values = InstanceManager.getInstanceValuesByAutoForm();
      Meteor.call("inbox_save_instance", myApprove, function(error, result) {
        Session.set('change_date', new Date());
        WorkflowManager.instanceModified.set(false);
        if (result == true) {

          toastr.success(TAPi18n.__('Attachment deleted successfully'));
        } else {
          toastr.error(error);
        }
      });
    }
  }
}

// 上传附件
InstanceManager.uploadAttach = function(files, isAddVersion) {
  $(document.body).addClass("loading");
  $('.loading-text').text(TAPi18n.__("workflow_attachment_uploading"));

  // 专业版文件大小不能超过100M
  var maximumFileSize = 100 * 1024 * 1024;
  // 免费版大小不能超过1M
  var freeMaximumFileSize = 1024 * 1024;

  var limitSize, warnStr;

  var is_paid = WorkflowManager.isPaidSpace(Session.get('spaceId'));

  if (is_paid) {
    limitSize = maximumFileSize;
    warnStr = t("workflow_attachment_paid_size_limit");
  } else {
    limitSize = freeMaximumFileSize;
    warnStr = t("workflow_attachment_free_size_limit");
  }

  var fd, file, fileName, i;

  i = 0;

  while (i < files.length) {
    file = files[i];

    if (file.size > limitSize) {
      swal({
        title: warnStr,
        type: "warning",
        confirmButtonText: t('OK'),
        closeOnConfirm: true
      }, function() {
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
      });
      return;
    }

    if (!file.name) {
      continue;
    }
    fileName = file.name;
    if (["image.jpg", "image.gif", "image.jpeg", "image.png"].includes(fileName.toLowerCase())) {
      fileName = "image-" + moment(new Date()).format('YYYYMMDDHHmmss') + "." + fileName.split('.').pop();
    }
    Session.set("filename", fileName);
    $('.loading-text').text(TAPi18n.__("workflow_attachment_uploading") + fileName + "...");
    fd = new FormData;
    fd.append('Content-Type', cfs.getContentType(fileName));
    fd.append("file", file);
    fd.append("instance", Session.get('instanceId'));
    fd.append("space", Session.get('spaceId'));
    fd.append("approve", InstanceManager.getMyApprove().id);
    fd.append("owner", Meteor.userId());
    fd.append("owner_name", Meteor.user().name);
    if (isAddVersion) {
      fd.append("isAddVersion", isAddVersion);
      fd.append("parent", Session.get('attach_parent_id'));
    }

    $.ajax({
      url: Meteor.absoluteUrl('s3/'),
      type: 'POST',
      async: true,
      data: fd,
      dataType: 'json',
      processData: false,
      contentType: false,
      success: function(responseText, status) {
        var fileObj;
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
        if (responseText.errors) {
          responseText.errors.forEach(function(e) {
            toastr.error(e.errorMessage);
          });
          return;
        }
        fileObj = {};
        fileObj._id = responseText.version_id;
        fileObj.name = Session.get('filename');
        fileObj.type = cfs.getContentType(Session.get('filename'));
        fileObj.size = responseText.size;
        InstanceManager.addAttach(fileObj, isAddVersion);
      },
      error: function(xhr, msg, ex) {
        $(document.body).removeClass('loading');
        $('.loading-text').text("");
        toastr.error(msg);
      }
    });
    i++;
  }
}

InstanceManager.lockAttach = function(file_id) {
  return cfs.instances.update({
    _id: file_id
  }, {
    $set: {
      'metadata.locked_by': Meteor.userId(),
      'metadata.locked_by_name': Meteor.user().name
    }
  });
}

InstanceManager.isInbox = function() {
  var instance = WorkflowManager.getInstance();
  var currentUser = Meteor.userId();

  if (instance && currentUser && Session.get("box") == 'inbox') {

    if (instance.inbox_users && instance.inbox_users.includes(currentUser)) {
      return true;
    }

    if (InstanceManager.isCC(instance)) {
      return true;
    }

  }

  return false;
}

InstanceManager.isCC = function(instance) {
  var currentUser = Meteor.userId();
  var approve = InstanceManager.getCurrentApprove();

  if (approve && approve.type != "cc") {
    return false;
  }

  if (instance.cc_users && instance.cc_users.includes(currentUser))
    return true;

  return false;
}

InstanceManager.getCCApprove = function(userId, is_finished) {

  var instance = WorkflowManager.getInstance();

  var traces = instance.traces;

  var rev = {};

  traces.forEach(function(t) {
    t.approves.forEach(function(approve) {
      if (approve.user == userId && approve.type == 'cc' && approve.is_finished == is_finished) {
        rev = approve
      }
    });
  })

  return rev;
}

InstanceManager.unlockAttach = function(file_id) {
  return cfs.instances.update({
    _id: file_id
  }, {
    $unset: {
      'metadata.locked_by': '',
      'metadata.locked_by_name': ''
    }
  });
}

// 申请单转发
InstanceManager.forwardIns = function(instance_id, space_id, flow_id) {
  Meteor.call('forward_instance', instance_id, space_id, flow_id, function(error, result) {
    if (error) {
      toastr.error(error.message);
    }

    if (result) {
      FlowRouter.go("/workflow/space/" + space_id + "/draft/" + result);
    }

  })
}