Meteor.startup(function () {

  if (Meteor.settings.cron && Meteor.settings.cron.bqq) {

    var schedule = require('node-schedule');
    // 定时执行同步
    var rule = Meteor.settings.cron.bqq;

    var go_next = true;

    schedule.scheduleJob(rule, Meteor.bindEnvironment(function () {
      if (!go_next)
        return;
      go_next = false;

      console.time('bqq');
      var spaces = db.spaces.find({"services.bqq.company_id": {$exists: true}, "services.bqq.company_token": {$exists: true}, "services.bqq.modified": {$exists: true} });
      var result = [];

      spaces.forEach(function(s){
        try {
          BQQ.debug && console.log(s.name);
          var auth = s.services.bqq;
          var c = BQQ.loginCheckGet(auth);
          if (c.ret > 0) {
            var r = BQQ.companyRefreshGet(auth);
            auth.company_token = r.company_token;
            auth.expires_in = r.expires_in;
            auth.refresh_token = r.refresh_token;
            db.spaces.direct.update({_id: s._id}, {$set: {'services.bqq': auth}});
          } 

          BQQ.syncCompany(auth);
        }
        catch (err) {
          e = {};
          e._id = s._id;
          e.name = s.name;
          e.services = s.services;
          e.err = err;
          result.push(e);
          console.error(e);
        }
      });

      if (result.length > 0) {
        try {
          var Email = Package.email.Email;
          Email.send({
            to: 'support@steedos.com',
            from: Accounts.emailTemplates.from,
            subject: 'bqq sync result',
            text: JSON.stringify({'result': result})
          });
        } catch (err) {
          console.error(err);
        }
      }

      console.timeEnd('bqq');

      go_next = true;

    }, function () {
      console.log('Failed to bind environment');
    }));

  }

})