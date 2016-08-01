JsonRoutes.add("get", "/api/bqq/companyToken", function (req, res, next) {
  var config = ServiceConfiguration.configurations.findOne({service: 'bqq'});
  var response;
  console.log("companyToken")
  console.log(req.query)
  try {
    response = HTTP.get(
      "https://openapi.b.qq.com/oauth2/companyToken", {
        params: {
          code: req.query.code,
          app_id: config.clientId,
          redirect_uri: "https://cn.steedos.com/api/bqq/companyToken", //OAuth._redirectUri("bqq", config),
          app_secret: OAuth.openSecret(config.secret),
          grant_type: 'authorization_code'
        }
      });

    if (response.error_code) // if the http response was an error
        throw response.msg;

    if (response.data.ret > 0) 
      throw response.data.msg;

  } catch (err) {
    throw _.extend(new Error("Failed to complete OAuth handshake with QQ. " + err),
                   {response: err.response});
  }

  console.log(response.data);

  BQQ.syncCompany(response.data.data);

  JsonRoutes.sendResult(res, {
    data: {
      ret: 0,
      msg: "成功"
    }
  });
});

// 从企业QQ跳转入口和事件通知
JsonRoutes.add("get", "/api/bqq/notify", function (req, res, next) {
  var config = ServiceConfiguration.configurations.findOne({service: 'bqq'});

  console.log("/api/bqq/notify");
  console.log(req.query);

  var query = req.query;
  
  var 
    notify_type_id = query.notify_type_id,
    timestamp = query.timestamp,
    company_id = query.company_id
  ;

  // 5）从客户端跳转 单点登录
  if (notify_type_id == 5) {
    var 
      open_id = query.open_id,
      hashskey = query.hashskey,
      returnurl = query.returnurl
    ;
    var space = db.spaces.findOne({'services.bqq.company_id': company_id});
    if (!space)
      return;
    // 校验其有效性 /api/login/verifyhashskey
    var oauth = space.services.bqq;

    try {
      var response = HTTP.get(
        "https://openapi.b.qq.com/api/login/verifyhashskey", {
          params: {
            company_id: company_id,
            company_token: oauth.company_token,
            open_id: open_id,
            app_id: config.clientId,
            client_ip: "0.0.0.0",
            oauth_version: 2,
            hashskey: hashskey
          }
        });

      if (response.error_code) 
          throw response.msg;

      if (response.data.ret > 0) 
        throw response.data.msg;

    } catch (err) {
      console.log(err);
      throw _.extend(new Error("Failed to verify hashskey with QQ. " + err),
                     {response: err.response});
    }

    var user = db.users.findOne({"services.bqq.id": open_id});
    if (!user)
      return;

    var userId = user._id;

    var authToken = Accounts._generateStampedLoginToken();
    var hashedToken = Accounts._hashLoginToken(authToken.token);
    Accounts._insertHashedLoginToken(userId, {hashedToken: hashedToken});

    Setup.setAuthCookies(req, res, userId, authToken)

    //var sso_url = '/workflow/sso?userId=' + userId + '&authToken=' + authToken.token + '&redirect=' + returnurl;

    JsonRoutes.sendResult(res, {
      headers: {
        'Location': returnurl,
      },
      code: 301
    });
  } else {
    var now_time = new Date().getTime();
    var space = db.spaces.findOne({"services.bqq.company_id": company_id});
    if (space) {
      db.spaces.direct.update(space._id, {$set:{"services.bqq.modified": now_time}});
    }



    JsonRoutes.sendResult(res, {
      data: {
        ret: 0,
        msg: "成功"
      }
    });
  }
















  
});
