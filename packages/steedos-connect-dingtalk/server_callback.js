var WXBizMsgCrypt = require('wechat-crypto');
//钉钉文档：http://ddtalk.github.io/dingTalkDoc/?spm=a3140.7785475.0.0.p5bAUd#2-回调接口（分为五个回调类型）

var config = {
  token: "steedos",
  encodingAESKey: "vr8r85bhgaruo482zilcyf6uezqwpxpf88w77t70dow",
  suiteKey: "suitedjcpb8olmececers"
}

//suite4xxxxxxxxxxxxxxx 是钉钉默认测试suiteid 
var newCrypt = new WXBizMsgCrypt(config.token, config.encodingAESKey, config.suiteKey || 'suite4xxxxxxxxxxxxxxx');
var TICKET_EXPIRES_IN = config.ticket_expires_in || 1000 * 60 * 20 //20分钟

JsonRoutes.add("post", "/api/dingtalk/callback", function(req, res, next) {

  var signature = req.query.signature;
  var timestamp = req.query.timestamp;
  var nonce = req.query.nonce;
  var encrypt = req.body.encrypt;

  if (signature !== newCrypt.getSignature(timestamp, nonce, encrypt)) {
    res.writeHead(401);
    res.end('Invalid signature');
    return;
  }

  var result = newCrypt.decrypt(encrypt);
  var message = JSON.parse(result.message);
  var eventType = message.EventType;
  if (eventType === 'check_update_suite_url' || eventType === 'check_create_suite_url') { //创建套件第一步，验证有效性。
    var Random = message.Random;
    result = Dingtalk._jsonWrapper(timestamp, nonce, Random);
    JsonRoutes.sendResult(res, {
      data: result
    });

  } else {
    res.reply = function() { //返回加密后的success
        result = Dingtalk._jsonWrapper(timestamp, nonce, 'success');
        JsonRoutes.sendResult(res, {
          data: result
        });
      }
      // 通讯录事件回调
    var address_call_back_tag = ['user_add_org', 'user_modify_org', 'user_leave_org', 'org_admin_add', 'org_admin_remove', 'org_dept_create', 'org_dept_modify', 'org_dept_remove', 'org_remove'];

    if (eventType === 'suite_ticket') {
      // var data = {
      //   value: message.SuiteTicket,
      //   expires: Number(message.TimeStamp) + TICKET_EXPIRES_IN
      // }
      // config.saveTicket(data, function(err) {
      //   if (err) {
      //     return next(err);
      //   } else {
      //     res.reply();
      //   }
      // });
      var o = ServiceConfiguration.configurations.findOne({
        service: "dingtalk"
      });
      if (o) {
        r = Dingtalk.suiteAccessTokenGet(o.suite_key, o.suite_secret, message.SuiteTicket);
        if (r && r.suite_access_token) {
          ServiceConfiguration.configurations.update(o._id, {
            $set: {
              "suite_ticket": message.SuiteTicket,
              "suite_access_token": r.suite_access_token
            }
          });
        }

      }
      res.reply();
    }
    // 回调向ISV推送临时授权码
    else if (eventType === 'tmp_auth_code') {
      var tmp_auth_code = message.AuthCode;
      // var suiteKey = message.SuiteKey;
      var o = ServiceConfiguration.configurations.findOne({
        service: "dingtalk"
      });
      if (o && o.suite_access_token) {

        r = Dingtalk.permanentCodeGet(o.suite_access_token, tmp_auth_code);
        if (r && r.permanent_code) {

          // 同步
          var permanent_code = r.permanent_code;
          var auth_corp_info = r.auth_corp_info;

          var at = Dingtalk.corpTokenGet(o.suite_access_token, auth_corp_info.corpid, permanent_code);
          if (at && at.access_token) {
            Dingtalk.syncCompany(at.access_token, auth_corp_info, permanent_code);
          }

          // 激活授权套件
          Dingtalk.activateSuitePost(o.suite_access_token, o.suite_key, auth_corp_info.corpid, permanent_code);
        }

      }

      res.reply();
    }
    // “解除授权”事件
    else if (eventType === 'suite_relieve') {
      var corp_id = message.AuthCorpId;
      var space = db.spaces.findOne({
        'services.dingtalk.corp_id': corp_id
      });
      if (space) {
        var s_dt = space.services.dingtalk;
        s_dt.permanent_code = undefined;
        db.spaces.direct.update({
          _id: space._id
        }, {
          $set: {
            'services.dingtalk': s_dt
          }
        });
      }
      res.reply();
    }
    // 通讯录事件回调
    else if (address_call_back_tag.includes(eventType)) {
      var corp_id = message.CorpId;
      // 企业被解散
      if (eventType === 'org_remove') {
        var space = db.spaces.findOne({
          'services.dingtalk.corp_id': corp_id
        });
        if (space) {
          var s_dt = space.services.dingtalk;
          s_dt.permanent_code = undefined;
          db.spaces.direct.update({
            _id: space._id
          }, {
            $set: {
              'services.dingtalk': s_dt
            }
          });
        }
      } else {
        db.spaces.direct.update({
          'services.dingtalk.corp_id': corp_id
        }, {
          $set: {
            'services.dingtalk.modified': new Date()
          }
        });
      }

      res.reply();
    } else {
      Dingtalk.processCallback(message, req, res, next);
    }

  };
});

Dingtalk.processCallback = function(message, req, res, next) {

  res.reply();
}

Dingtalk._jsonWrapper = function(timestamp, nonce, text) {
  var encrypt = newCrypt.encrypt(text);
  var msg_signature = newCrypt.getSignature(timestamp, nonce, encrypt); //新签名
  return {
    msg_signature: msg_signature,
    encrypt: encrypt,
    timeStamp: timestamp,
    nonce: nonce
  };
}

// 手动初始化
JsonRoutes.add("post", "/api/dingtalk/init", function(req, res, next) {

  res.reply = function(result) {
    JsonRoutes.sendResult(res, {
      data: result
    });
  }

  var corpid = req.query.corpid;
  var corpsecret = req.query.corpsecret;
  var corp_name = req.query.corp_name;

  if (!corpid)
    res.reply("need corpid!");

  if (!corpsecret)
    res.reply("need corpsecret!");

  if (!corp_name)
    res.reply("need corp_name!");


  var access_token = Dingtalk.getToken(corpid, corpsecret);

  if (access_token) {
    var auth_corp_info = {};
    auth_corp_info.corpid = corpid;
    auth_corp_info.corp_name = corp_name;
    Dingtalk.syncCompany(access_token, auth_corp_info, undefined);
  }

  JsonRoutes.sendResult(res, {
    data: "success"
  });

});

// dingtalk免登给用户设置cookies
JsonRoutes.add("post", "/api/dingtalk/sso_steedos", function(req, res, next) {

  res.reply = function(result) {
    JsonRoutes.sendResult(res, {
      data: result
    });
  }

  var access_token = req.body.access_token;
  var code = req.body.code;

  if (!code || !access_token)
    res.reply("缺少参数!");

  var user_info, user_detail, user;
  user_info = Dingtalk.userInfoGet(access_token, code);

  if (user_info && user_info.userid) {
    user_detail = Dingtalk.userGet(access_token, user_info.userid);

    if (user_detail && user_detail.dingId) {
      user = db.users.findOne({
        'services.dingtalk.id': user_detail.dingId
      });
      if (user) {
        var userId = user._id;
        var authToken = Accounts._generateStampedLoginToken();
        var hashedToken = Accounts._hashStampedToken(authToken);
        Accounts._insertHashedLoginToken(userId, hashedToken);

        Setup.setAuthCookies(req, res, userId, authToken.token);

        JsonRoutes.sendResult(res, {
          data: 'success'
        });
      } else {
        res.reply("用户不存在!");
      }
    } else {
      res.reply("用户不存在!");
    }
  } else {
    res.reply("用户不存在!");
  }

});