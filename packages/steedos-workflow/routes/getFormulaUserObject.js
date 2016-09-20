JsonRoutes.add("post", "/api/workflow/getFormulaUserObject", function (req, res, next) {
  var
    userId = req.body.userId,
    spaceId = req.query.spaceId,
    userObject = {}
  ;

  if (!userId || !spaceId) {
    JsonRoutes.sendResult(res, {
      code: 200,
      data: {
        'errors': '缺少参数'
      }
    });
  }

  var user = WorkflowManager.getUser(spaceId, userId);

  userObject['id'] = userId;
  userObject['name'] = user.name;
  userObject['organization'] = {'name':user.organization.name,'fullname':user.organization.fullname};
  userObject["roles"] = user.roles ? user.roles.getProperty('name'):[];

  JsonRoutes.sendResult(res, {
    code: 200,
    data: {
      'spaceUser': userObject
    }
  });
})


  
  