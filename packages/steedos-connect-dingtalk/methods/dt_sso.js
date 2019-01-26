var crypto = require('crypto');


Dingtalk.sign = function(ticket, nonceStr, timeStamp, url) {
    var plain = 'jsapi_ticket=' + ticket +
        '&noncestr=' + nonceStr +
        '&timestamp=' + timeStamp +
        '&url=' + url;

    var sha1 = crypto.createHash('sha1');
    sha1.update(plain, 'utf8');
    var signature = sha1.digest('hex');
    return signature;
}

Meteor.methods({
    dingtalk_sso: function(corpid, url) {
        check(corpid, String);

        var _config;

        var s = db.spaces.findOne({
            'services.dingtalk.corp_id': corpid,
            "services.dingtalk.permanent_code": {
                $exists: true
            }
        });

        if (!s)
            throw new Meteor.Error('params error!', 'record not exists!');

        var o = ServiceConfiguration.configurations.findOne({
            service: "dingtalk"
        });
        if (o && o.suite_access_token && o.suite_key) {
            Dingtalk.debug && console.log(s.name);
            var permanent_code = s.services.dingtalk.permanent_code;
            var suite_access_token = o.suite_access_token;
            var suite_key = o.suite_key;
            var at = Dingtalk.corpTokenGet(suite_access_token, corpid, permanent_code);
            if (at && at.access_token) {
                Dingtalk.debug && console.log(at.access_token);
                var access_token = at.access_token;
                var jsapi_ticket = Dingtalk.jsapiTicketGet(access_token);
                var ticket = jsapi_ticket.ticket;
                var nonceStr = 'steedos';
                var timeStamp = new Date().getTime();

                var signature = Dingtalk.sign(ticket, nonceStr, timeStamp, url);

                var auth_info = Dingtalk.authInfoGet(suite_access_token, suite_key, corpid, permanent_code);

                var agent = _.find(auth_info.auth_info.agent, function(a) {
                    return a.agent_name == '审批王';
                });

                _config = {
                    signature: signature,
                    nonceStr: nonceStr,
                    timeStamp: timeStamp,
                    url: url,
                    corpId: corpid,
                    agentId: agent.agentid,
                    access_token: access_token
                };
            }

        }

        return _config;
    }

})