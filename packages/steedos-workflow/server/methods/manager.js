Meteor.methods({

    //审批时指定人员
    nextUserType_pickupAtRuntime: function () {
        
    },

    // 指定人员
    nextUserType_specifyUser: function (spaceId, userIds) {
        console.log('method===>nextUserType_specifyUser');
        console.log(spaceId);
        console.log(userIds);
        var nextStepUsers = WorkflowManager.getUsers(spaceId, userIds);
        return nextStepUsers;
    },

    // 申请人所属组织中的审批岗位
    nextUserType_applicantRole: function (spaceId, applicantId, roleIds) {
        console.log('method===>nextUserType_applicantRole');
        var applicant = WorkflowManager.getUser(spaceId, applicantId);
        var nextStepUsers = WorkflowManager.getRoleUsersByOrgAndRoles(spaceId, applicant.organization.id, roleIds);
        return nextStepUsers;
    },

    // 申请人上级
    nextUserType_applicantSuperior: function (spaceId, applicantId) {
        console.log('method===>nextUserType_applicantSuperior');
        var applicant = WorkflowManager.getUser(spaceId, applicantId);
        var nextStepUsers = WorkflowManager.getUsers(spaceId, applicant.manager);
        return nextStepUsers;
    },

    // 申请人
    nextUserType_applicant: function (spaceId, applicantId) {
        console.log('method===>nextUserType_applicant');
        var nextStepUsers = WorkflowManager.getUsers(spaceId, applicantId);
        return nextStepUsers;
    },

    // 指定人员字段
    nextUserType_userField: function (spaceId, userField, userFieldValue) {
        console.log('method===>nextUserType_userField');
        var nextStepUsers;
        if(userField.is_multiselect){ //如果多选，以userFieldValue值为Array
            nextStepUsers = WorkflowManager.getUsers(userFieldValue);
        }
        else {
            nextStepUsers.push(WorkflowManager.getUser(userFieldValue));
        }
        return nextStepUsers;
    },

    // 指定部门字段
    nextUserType_orgField: function (spaceId, orgField, orgFieldValue) {
        console.log('method===>nextUserType_orgField');
        var orgs, orgChildrens, nextStepUsers;
        if(orgField.is_multiselect){//如果多选，以orgFieldValue值为Array
            orgs = WorkflowManager.getOrganizations(orgFieldValue);
            orgChildrens = WorkflowManager.getOrganizationsChildrens(spaceId, orgFieldValue);
        } 
        else {
            orgs = [WorkflowManager.getOrganization(orgFieldValue)];
            orgChildrens = WorkflowManager.getOrganizationChildrens(spaceId, orgFieldValue);
        }

        nextStepUsers = WorkflowManager.getOrganizationsUsers(spaceId, orgChildrens);
        
        orgFieldUsers = WorkflowManager.getOrganizationsUsers(spaceId, orgs);

        nextStepUsers = nextStepUsers.concat(orgFieldUsers);

        return nextStepUsers;
    },

    // 指定部门
    nextUserType_specifyOrg: function (spaceId, specifyOrgIds) {
        console.log('method===>nextUserType_specifyOrg');
        var nextStepUsers;
        var specifyOrgs = WorkflowManager.getOrganizations(specifyOrgIds);
        var specifyOrgChildrens = WorkflowManager.getOrganizationsChildrens(spaceId,specifyOrgIds);

        nextStepUsers = WorkflowManager.getOrganizationsUsers(spaceId, specifyOrgs);
        nextStepUsers = nextStepUsers.concat(WorkflowManager.getOrganizationsUsers(spaceId, specifyOrgChildrens));
        return nextStepUsers;
    },

    // 指定部门字段相关审批岗位
    nextUserType_userFieldRole: function (spaceId, userField, userFieldValue, approverRoleIds) {
        console.log('method===>nextUserType_userFieldRole');
        var nextStepUsers;
        if(userField.is_multiselect){//如果多选，以userFieldValue值为Array
            nextStepUsers = WorkflowManager.getRoleUsersByUsersAndRoles(spaceId, userFieldValue, approverRoleIds);
        }else{
            nextStepUsers = WorkflowManager.getRoleUsersByUsersAndRoles(spaceId, [userFieldValue], approverRoleIds);
        }
        return nextStepUsers;
    },

    // 指定部门字段相关审批岗位
    nextUserType_orgFieldRole: function (spaceId, orgField, orgFieldValue, approverRoleIds) {
        console.log('method===>nextUserType_orgFieldRole');
        var nextStepUsers;
        if(orgField.is_multiselect){//如果多选，以orgFieldValue值为Array
            nextStepUsers = WorkflowManager.getRoleUsersByOrgsAndRoles(instance.space, orgFieldValue, approverRoleIds);
        }else{
            nextStepUsers = WorkflowManager.getRoleUsersByOrgsAndRoles(instance.space, [orgFieldValue], approverRoleIds);
        }
        return nextStepUsers;
    }



})
    