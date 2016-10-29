JsonRoutes.add("post", "/api/workflow/getFormulaUserObjects", function (req, res, next) {
  var
    userIds = req.body.userIds,
    spaceId = req.query.spaceId,
    spaceUsers = []
  ;

  if (!userIds || !spaceId) {
    JsonRoutes.sendResult(res, {
      code: 200,
      data: {
        'errors': '缺少参数'
      }
    });
  }

  var users = WorkflowManager.getUsers(spaceId, userIds);

  users.forEach(function (user) {
    var userObject = {};
    userObject['id'] = user.id;
    userObject['name'] = user.name;
    userObject['organization'] = {'name':user.organization.name,'fullname':user.organization.fullname};
    userObject["roles"] = user.roles ? user.roles.getProperty('name'):[];
    spaceUsers.push(userObject);
  })

  JsonRoutes.sendResult(res, {
    code: 200,
    data: {
      'spaceUsers': spaceUsers
    }
  });
})


  
  