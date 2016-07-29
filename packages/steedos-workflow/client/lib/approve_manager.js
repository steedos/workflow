ApproveManager = {};

ApproveManager.error = {nextSteps:'',nextStepUsers:''}

ApproveManager.isReadOnly = function(){
    var ins = WorkflowManager.getInstance();
    if(!ins)
        return true;
    // 系统启动时，可能flow还没获取到。
    var flow = db.flows.findOne(ins.flow);
    if (!flow)
        return true;

    if (ins.state != 'completed' && ((Session.get("box")=="draft"&&flow.state=="enabled") || Session.get("box")=="inbox"))
        return false;
    else
        return true;
}

ApproveManager.getNextSteps = function(instance, currentStep, judge, autoFormDoc, fields){
    ApproveManager.error.nextSteps = '';
    console.log("getNextSteps");
    if(!currentStep)
        return ;

    var nextSteps = new Array();
    var lines = currentStep.lines;

    switch(currentStep.step_type){
        case 'condition': //条件
            nextSteps = Form_formula.getNextStepsFromCondition(currentStep, autoFormDoc, fields);
            if(!nextSteps.length)
                ApproveManager.error.nextSteps = '未能根据条件找到下一步';
            break;
        case 'end': //结束
            return next_steps;
        case 'sign': //审批
            if(judge == 'approved'){ //核准
                lines.forEach(function(line){
                    if(line.state == "approved"){
                        nextSteps.push(WorkflowManager.getInstanceStep(line.to_step));
                    }
                })
            }else if(judge=="rejected"){ //驳回
                lines.forEach(function(line){
                    if(line.state == "rejected"){
                        var rejected_step = WorkflowManager.getInstanceStep(line.to_step);
                        // 驳回时去除掉条件节点
                        if(rejected_step && rejected_step.step_type != "condition")
                            nextSteps.push(rejected_step);
                    }
                })

                var traces = instance.traces;

                traces.forEach(function(trace){
                    if(trace.is_finished == true){
                        var finished_step = WorkflowManager.getInstanceStep(trace.step);
                        if(finished_step.step_type != 'condition' && currentStep.id != finished_step.id)
                            nextSteps.push(finished_step);
                    }
                });

            }
            break;
        default: //start：开始、submit：填写、counterSign：会签
            lines.forEach(function(line){
                if(line.state == "submitted"){
                    var submitted_step = WorkflowManager.getInstanceStep(line.to_step);
                    if(submitted_step)
                        nextSteps.push(submitted_step);
                }
            });
            break;
    }

    //去除重复
    nextSteps = nextSteps.uniqById();

    //按照步骤名称排序(升序)
    nextSteps.sort(function(p1,p2){
        return p1.name.localeCompare(p2.name);
    });

    var condition_next_steps = new Array();
    nextSteps.forEach(function(nextStep){
        if(nextStep.step_type == "condition"){
            condition_next_steps = condition_next_steps.concat(ApproveManager.getNextSteps(instance, nextStep, judge, autoFormDoc, fields));
        }
    })

    nextSteps = nextSteps.concat(condition_next_steps);

    var rev_nextSteps = new Array();

    nextSteps.forEach(function(nextStep){
        if(nextStep.step_type != "condition")
            rev_nextSteps.push(nextStep);
    });


    //去除重复
    rev_nextSteps = rev_nextSteps.uniqById();

    // 会签节点，如果下一步有多个 则清空下一步
    if (currentStep.step_type == "counterSign" && rev_nextSteps.length > 1){
        rev_nextSteps = [];
    }
    return rev_nextSteps;
};

ApproveManager.getNextStepUsers = function(instance, nextStepId){
    ApproveManager.error.nextStepUsers = '';
    var nextStepUsers = new Array();

    var nextStep = WorkflowManager.getInstanceStep(nextStepId);

    if (!nextStep)
        return ;

    var applicant = WorkflowManager.getUser(InstanceManager.getApplicantUserId());
    Session.set("next_step_users_showOrg",false);
    switch(nextStep.step_type){
        case 'condition':
            break;
        case 'start': //下一步步骤类型为开始
            nextStepUsers.push(applicant);
            break;
        default:
            switch(nextStep.deal_type){
                case 'pickupAtRuntime': //审批时指定人员
                    Session.set("next_step_users_showOrg",true);
                    nextStepUsers = WorkflowManager.getSpaceUsers(instance.space);
                    break;
                case 'specifyUser': //指定人员
                    var specifyUserIds = nextStep.approver_users;
                    nextStepUsers = nextStepUsers.concat(WorkflowManager.getUsers(specifyUserIds));
                    break;
                case 'applicantRole': //指定审批岗位
                    var approveRoleIds = nextStep.approver_roles;
                    var approveRoles = WorkflowManager.getRoles(approveRoleIds);
                    nextStepUsers = WorkflowManager.getRoleUsersByOrgAndRoles(instance.space, applicant.organization.id, approveRoleIds);
                    if(!nextStepUsers.length){
                        //todo 记录未找到角色人员的原因，用于前台显示
                        ApproveManager.error.nextStepUsers = '"' + approveRoles.getProperty('name').toString() + '"审批岗位未指定审批人';
                        console.error("步骤: " + nextStep.name + "找指定岗位处理人失败。参数：orgId is " + applicant.organization.id + ";roleIds is " + approveRoleIds);
                    }
                    break;
                case 'applicantSuperior': //申请人上级
                    nextStepUsers = WorkflowManager.getUsers(applicant.manager);
                    break;
                case 'applicant': //申请人
                    nextStepUsers.push(applicant);
                    break;
                case 'userField': //指定人员字段
                    var userFieldId =  nextStep.approver_user_field;
                    var userField = InstanceManager.getFormField(userFieldId);
                    if(userField){
                        var userFieldValue = InstanceManager.getFormFieldValue(userField.code);
                        if(userFieldValue){
                            if(userField.is_multiselect){ //如果多选，以userFieldValue值为Array
                                nextStepUsers = WorkflowManager.getUsers(userFieldValue);
                            }else{
                                nextStepUsers.push(WorkflowManager.getUser(userFieldValue));
                            }
                        }
                    }
                    if(!nextStepUsers.length){
                       //todo 记录记录未找到的原因，用于前台显示
                       ApproveManager.error.nextStepUsers = '"' + userField.code + '"字段没有值';
                       console.error("步骤: " + nextStep.name + "fieldId is " + userFieldId);
                    }
                    break;
                case 'orgField': //指定部门字段
                    var orgFieldId = nextStep.approver_org_field;
                    var orgField = InstanceManager.getFormField(orgFieldId);
                    var orgs = new Array();

                    if(orgField){
                        var orgFieldValue = InstanceManager.getFormFieldValue(orgField.code);

                        var orgChildrens = new Array();

                        //获得orgFieldValue的所有子部门
                        if(orgFieldValue){
                            if(orgField.is_multiselect){//如果多选，以orgFieldValue值为Array
                                orgs = WorkflowManager.getOrganizations(orgFieldValue);
                                orgChildrens = WorkflowManager.getOrganizationsChildrens(instance.space, orgFieldValue);
                            }else{
                                orgs = [WorkflowManager.getOrganization(orgFieldValue)];
                                orgChildrens = WorkflowManager.getOrganizationChildrens(instance.space, orgFieldValue);
                            }

                            nextStepUsers = WorkflowManager.getOrganizationsUsers(instance.space, orgChildrens);
                            
                            orgFieldUsers = WorkflowManager.getOrganizationsUsers(instance.space, orgs);

                            nextStepUsers = nextStepUsers.concat(orgFieldUsers);
                        }
                    }

                    if(!nextStepUsers.length){
                        if(!orgs.length){
                            ApproveManager.error.nextStepUsers = '"' + orgField.code + '"字段没有值';
                        }else{
                            ApproveManager.error.nextStepUsers = '"' + orgs.concat(orgChildrens).getProperty('name').toString() + '"部门中没有人员';
                        }
                    }
                    break;
                case 'specifyOrg': //指定部门
                    var specifyOrgIds = nextStep.approver_orgs;

                    var specifyOrgs = WorkflowManager.getOrganizations(specifyOrgIds);
                    var specifyOrgChildrens = WorkflowManager.getOrganizationsChildrens(instance.space,specifyOrgIds);

                    nextStepUsers = WorkflowManager.getOrganizationsUsers(instance.space, specifyOrgs);
                    nextStepUsers = nextStepUsers.concat(WorkflowManager.getOrganizationsUsers(instance.space, specifyOrgChildrens));
                    if(!nextStepUsers.length){
                        ApproveManager.error.nextStepUsers = '"' + specifyOrgs.concat(specifyOrgChildrens).getProperty('name').toString() + '"部门中没有人员';
                    }
                    break;
                case 'userFieldRole': //指定人员字段相关审批岗位

                    var approverRoleIds = nextStep.approver_roles;
                    var userFieldId = nextStep.approver_user_field;
                    var userField = InstanceManager.getFormField(userFieldId);
                    var userFieldValue;
                    if (userField){
                        userFieldValue = InstanceManager.getFormFieldValue(userField.code);
                        if(userFieldValue){
                            if(userField.is_multiselect){//如果多选，以userFieldValue值为Array
                                nextStepUsers = WorkflowManager.getRoleUsersByUsersAndRoles(instance.space, userFieldValue, approverRoleIds);
                            }else{
                                nextStepUsers = WorkflowManager.getRoleUsersByUsersAndRoles(instance.space, [userFieldValue], approverRoleIds);
                            }
                        }
                    }

                    if(!nextStepUsers.length){
                        
                        if(!userFieldValue){
                            ApproveManager.error.nextStepUsers = '"' + userField.code + '"字段没有值';
                        }else{
                            var approverRoles = WorkflowManager.getRoles(approverRoleIds);
                            ApproveManager.error.nextStepUsers = '"' + approverRoles.getProperty("name").toString() + '"审批岗位未指定审批人';
                        }
                    }

                    break;
                case 'orgFieldRole': //指定部门字段相关审批岗位
                    var approverRoleIds = nextStep.approver_roles;
                    var orgFieldId = nextStep.approver_org_field;
                    var orgField = InstanceManager.getFormField(orgFieldId);
                    var orgFieldValue;
                    if(orgField){
                        orgFieldValue = InstanceManager.getFormFieldValue(orgField.code);
                        if(orgFieldValue){
                            if(orgField.is_multiselect){//如果多选，以orgFieldValue值为Array
                                nextStepUsers = WorkflowManager.getRoleUsersByOrgsAndRoles(instance.space, orgFieldValue, approverRoleIds);
                            }else{
                                nextStepUsers = WorkflowManager.getRoleUsersByOrgsAndRoles(instance.space, [orgFieldValue], approverRoleIds);
                            }
                        }
                    }

                    if(nextStepUsers < 1){
                        if(!orgFieldValue){
                            ApproveManager.error.nextStepUsers = '"' + orgField.code + '"字段没有值';
                        }else{
                            var approverRoles = WorkflowManager.getRoles(approverRoleIds);
                            ApproveManager.error.nextStepUsers = '"' + approverRoles.getProperty("name").toString() + '"审批岗位未指定审批人';
                        }
                    }

                    break;
                default:
                    break;
            }
            break;
    }

    nextStepUsers = nextStepUsers.uniqById();

    //按照步骤名称排序(升序)
    nextStepUsers.sort(function(p1,p2){
        return p1.name.localeCompare(p2.name);
    });

    return nextStepUsers;

};

// ApproveManager.updateNextStepOptions = function(steps, judge){
//     console.log("updateNextStepOptions");
//     var lastSelected = ApproveManager.getNextStepsSelectValue();
    
//     $("#nextSteps").empty();

//     $("#nextSteps").select2().val(null).trigger("change");

//     if(!steps)
//         return;
    
//     steps.forEach(function(step){
//         $("#nextSteps").append("<option value='" + step.id + "'> " + step.name + " </option>");
//     });

//     if(steps.length > 1)
//         $("#nextSteps").prepend("<option value='-1'> 请选择 </option>");

//     $("#nextSteps").select2().val();
    
//     ApproveManager.setNextStepsSelectValue(steps, lastSelected);
// };

ApproveManager.getNextStepsSelectValue = function(){
    console.log("getNextStepsSelectValue");
    return $("#nextSteps").val();
}

// ApproveManager.setNextStepsSelectValue = function(steps, value){
//     console.log("setNextStepsSelectValue");
//     var lastStep = steps.filterProperty("_id", value);
    
//     if(lastStep.length > 0){
//         console.log("lastStep.length > 0");
//         $("#nextSteps").select2().val(value).trigger("change");
//     } else if(steps.length > 0){
//         console.log("steps.length > 0");
//         $("#nextSteps").select2().val(steps[0]._id).trigger("change");
//     }
// }

ApproveManager.getNextStepUsersSelectValue = function(){
    //return $("#nextStepUsers").val();
    var values = $("input[name='nextStepUsers']")[0].dataset.values;
    return values ? values.split(",") : [];
}

// ApproveManager.setNextStepUsersSelectValue = function(value){
//     console.log("setNextStepUsersSelectValue:");
//     console.log(value);
//     var n = [];
//     if(value && value.length > 0){
//         n = value;
//     } else {
//         console.log("setNextStepUsersSelectValue value is []");
//         var c = InstanceManager.getCurrentApprove();
//         if (c && c.next_steps && c.next_steps[0] && c.next_steps[0].users) {
//             n = c.next_steps[0].users;
//         }
//     }
//     if (n.length == 1) {
//         $("#nextStepUsers").select2().val(n[0]).trigger("change");
//     } else if (n.length > 1) {
//         $("#nextStepUsers").select2().val(n).trigger("change");
//     } else {
//         $("#nextStepUsers").select2().val(null).trigger("change");
//     }

//     $("#nextStepUsers").select2().val();
// }

// ApproveManager.updateNextStepUsersOptions = function(nextStep, users){
//     console.log("updateNextStepUsersOptions");
//     var lastSelected = new Array();
//     var selectedNextStepUsers = ApproveManager.getNextStepUsersSelectValue();

//     if(selectedNextStepUsers instanceof Array){
//         selectedNextStepUsers.forEach(function(su){
//           lastSelected.push(su.value);
//         });
//     }else{
//         if (selectedNextStepUsers) {
//             lastSelected.push(selectedNextStepUsers);
//         }
//     }
//     $("#nextStepUsers").empty();
//     $("#nextStepUsers").select2().val(null).trigger("change");
//     if(!users)
//         return;
    
//     if(nextStep.step_type == 'end'){
//         $("#nextStepUsers_div").hide();
//         return ;
//     }else{
//         $("#nextStepUsers_div").show();
//     }

//     if(nextStep.step_type == 'counterSign'){
//         $("#nextStepUsers").prop('multiple','multiple');
//         $("#nextStepUsers").select2();
//     }else{
//         $("#nextStepUsers").removeAttr('multiple');
//         $("#nextStepUsers").select2();
//     }

//     users.forEach(function(user){
//         $("#nextStepUsers").append("<option value='" + user.id + "'> " + user.name + " </option>");
//     });

//     /*
//     var u_ops = $("#nextStepUsers option").toArray();

    
//     u_ops.forEach(function(u_op){
//         if (lastSelected.includes(u_op.value))
//             u_op.selected = true;
//     });
//     */

//     if(users.length > 1 ){
//         $("#nextStepUsers").prepend("<option value='-1'> 请选择 </option>");
//     }

//     ApproveManager.setNextStepUsersSelectValue(lastSelected);
    
// }