WorkflowManager = {}

/*
返回指定部门下的角色成员,如果指定部门没有找到对应的角色，则会继续找部门的上级部门直到找到为止。
return [{spaceUser}]
*/
WorkflowManager.getRoleUsersbyOrgAndRole = function(spaceId, orgId, roleId) {

  var roleUsers = new Array();

  var spaceRoles = WorkflowManager.getSpaceRoles(spaceId);

  var spacePositions = WorkflowManager.getSpacePositions(spaceId);

  var rolePositions = spacePositions.filterProperty("role", roleId);

  var orgPositions = rolePositions.filterProperty("org", orgId);

  orgPositions.forEach(function(orgPosition) {
    var roleUserIds = orgPosition.users;
    roleUsers = roleUsers.concat(WorkflowManager.getUsers(spaceId, roleUserIds));
  });

  if (orgPositions.length == 0) {
    var organization = WorkflowManager.getOrganization(orgId);
    if (organization && organization.parent != '')
      roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersbyOrgAndRole(spaceId, organization.parent, roleId));
  }

  return roleUsers;
};

WorkflowManager.getRoleUsersByOrgAndRoles = function(spaceId, orgId, roleIds) {

  var roleUsers = new Array();

  roleIds.forEach(function(roleId) {
    roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersbyOrgAndRole(spaceId, orgId, roleId));
  });

  return roleUsers;

};

WorkflowManager.getRoleUsersByOrgsAndRoles = function(spaceId, orgIds, roleIds) {
  var roleUsers = new Array();

  if (!orgIds || !roleIds)
    return roleUsers;

  orgIds.forEach(function(orgId) {
    roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersByOrgAndRoles(spaceId, orgId, roleIds));
  });

  return roleUsers;
};

/*
返回用户所在部门下的角色成员.
return [{spaceUser}]
*/
WorkflowManager.getRoleUsersByUsersAndRoles = function(spaceId, userIds, roleIds) {

  var roleUsers = new Array();

  if (!userIds || !roleIds)
    return roleUsers;

  var users = WorkflowManager.getUsers(spaceId, userIds);

  users.forEach(function(user) {
    roleUsers = roleUsers.concat(WorkflowManager.getRoleUsersByOrgsAndRoles(spaceId, user.organizations, roleIds));
  });

  return roleUsers;
};

WorkflowManager.getSpaceRoles = function(spaceId) {
  if (!spaceId) {
    return;
  }

  var roles = new Array();

  var spaceRoles = db.flow_roles.find({
    space: spaceId
  });

  spaceRoles.forEach(function(spaceRole) {
    spaceRole.id = spaceRole._id;
    roles.push(spaceRole);
  });

  return roles;
};

WorkflowManager.getRole = function(spaceId, roleId) {

  if (!roleId || !spaceId) {
    return;
  }

  var spaceRoles = WorkflowManager.getSpaceRoles(spaceId),
    role = {};

  spaceRoles.forEach(function(spaceRole) {
    if (spaceRole.id == roleId) {
      role = spaceRole;
      return;
    }
  });

  return role;
};

WorkflowManager.getSpacePositions = function(spaceId) {
  var positions = new Array();

  var spacePositions = db.flow_positions.find({
    space: spaceId
  });

  spacePositions.forEach(function(spacePosition) {
    positions.push(spacePosition);
  });

  return positions;
};

//获取用户岗位
WorkflowManager.getUserRoles = function(spaceId, orgId, userId) {

  var userRoles = new Array();

  var spacePositions = WorkflowManager.getSpacePositions(spaceId);

  //orgRoles = spacePositions.filterProperty("org", orgId);
  var userPositions = spacePositions.filterProperty("users", userId);

  userPositions.forEach(function(userPosition) {
    userRoles.push(WorkflowManager.getRole(spaceId, userPosition.role));
  });

  return userRoles;
};

WorkflowManager.getOrganizationsUsers = function(spaceId, orgs) {

  var orgUsers = new Array();

  orgs.forEach(function(org) {
    orgUsers = orgUsers.concat(WorkflowManager.getUsers(spaceId, org.users));
  });

  return orgUsers;
}

//获取space下的所有部门
WorkflowManager.getSpaceOrganizations = function(spaceId) {
  var orgs = new Array();
  var spaceOrgs = db.organizations.find({
    space: spaceId
  });

  spaceOrgs.forEach(function(spaceOrg) {
    spaceOrg.id = spaceOrg._id
    orgs.push(spaceOrg);
  })

  return orgs;
};

WorkflowManager.getOrganizationChildrens = function(spaceId, orgId) {
  var spaceOrganizations = WorkflowManager.getSpaceOrganizations(spaceId);
  var chidrenOrgs = spaceOrganizations.filterProperty("parents", orgId);

  return chidrenOrgs;
};

WorkflowManager.getOrganizationsChildrens = function(spaceId, orgIds) {
  var chidrenOrgs = new Array();
  orgIds.forEach(function(orgId) {
    chidrenOrgs = chidrenOrgs.concat(WorkflowManager.getOrganizationChildrens(spaceId, orgId));
  });

  return chidrenOrgs;
};

WorkflowManager.getOrganization = function(orgId) {

  if (!orgId) {
    return;
  }

  var spaceOrg = db.organizations.findOne(orgId);

  if (!spaceOrg) {
    return;
  }

  spaceOrg.id = spaceOrg._id;

  return spaceOrg;
};

WorkflowManager.getOrganizations = function(orgIds) {
  if (!orgIds) {
    return [];
  }

  if ("string" == typeof(orgIds)) {
    return [WorkflowManager.getOrganization(orgIds)]
  }

  return db.organizations.find({
    _id: {
      $in: orgIds
    }
  }).fetch();
};

WorkflowManager.getUser = function(spaceId, userId) {
  if (!userId || !spaceId) {
    return;
  }

  if (typeof userId != "string") {

    return WorkflowManager.getUsers(spaceId, userId);

  }

  var spaceUser = db.space_users.findOne({
    space: spaceId,
    user: userId
  });

  if (!spaceUser) {
    return
  }

  spaceUser.id = spaceUser.user;
  spaceUser.organization = WorkflowManager.getOrganization(spaceUser.organization);
  if (!spaceUser.organization) {
    return;
  }
  spaceUser.roles = WorkflowManager.getUserRoles(spaceId, spaceUser.organization.id, spaceUser.id);

  return spaceUser;
};

WorkflowManager.getUsers = function(spaceId, userIds) {

  if ("string" == typeof(userIds)) {
    return [WorkflowManager.getUser(spaceId, userIds)]
  }

  var users = new Array();
  if (userIds && spaceId) {

    var spaceUsers = db.space_users.find({
      space: spaceId,
      user: {
        $in: userIds
      }
    });

    spaceUsers.forEach(function(spaceUser) {
      spaceUser.id = spaceUser.user;
      spaceUser.organization = WorkflowManager.getOrganization(spaceUser.organization);
      if (spaceUser.organization) {
        spaceUser.roles = WorkflowManager.getUserRoles(spaceId, spaceUser.organization.id, spaceUser.id);
        users.push(spaceUser);
      }
    })
  }

  return users;
};


WorkflowManager.getFormulaUsers = function(spaceId, userIds) {
  var spaceUsers = [];
  var users = WorkflowManager.getUsers(spaceId, userIds);
  users.forEach(function(user) {
    var userObject = {};
    userObject['id'] = user.id;
    userObject['name'] = user.name;
    userObject['organization'] = {
      'name': user.organization.name,
      'fullname': user.organization.fullname
    };
    userObject["roles"] = user.roles ? user.roles.getProperty('name') : [];
    spaceUsers.push(userObject);
  })

  return spaceUsers;
}

WorkflowManager.getFormulaUserObjects = function(spaceId, userIds) {
  if (!userIds)
    return;
  return WorkflowManager.getFormulaUserObject(spaceId, userIds);
}

WorkflowManager.getFormulaUserObject = function(spaceId, userId) {

  if (!userId)
    return;

  if (userId instanceof Array) {
    return WorkflowManager.getFormulaUsers(spaceId, userId);
  } else {
    return WorkflowManager.getFormulaUsers(spaceId, [userId])[0];
  }
};


WorkflowManager.getFormulaOrgObjects = function(orgIds) {
  if (!orgIds)
    return;
  return WorkflowManager.getFormulaOrgObject(orgIds);
}

WorkflowManager.getFormulaOrgObject = function(orgId) {

  if (orgId instanceof Array) {
    var orgArray = new Array();
    var orgs = WorkflowManager.getOrganizations(orgId);
    orgs.forEach(function(org) {
      var orgObject = {};
      orgObject['id'] = org._id;
      orgObject['name'] = org.name;
      orgObject['fullname'] = org.fullname;
      orgArray.push(orgObject);
    });

    return orgArray;
  } else {
    var orgObject = {};
    var org = WorkflowManager.getOrganization(orgId);
    if (!org)
      return null;

    orgObject['id'] = orgId;
    orgObject['name'] = org.name;
    orgObject['fullname'] = org.fullname;

    return orgObject;
  }

}