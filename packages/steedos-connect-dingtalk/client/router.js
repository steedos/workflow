FlowRouter.route('/steedos/dingtalk/sso_mobile', {
    action: function(params, queryParams) {
        if (!Meteor.userId() && queryParams.corpid) {
            Meteor.call('dingtalk_sso', queryParams.corpid, window.location.href, function(error, result) {
                if (error) {
                    swal("Error!", error.message, "error");
                }
                if (result) {
                    DingtalkManager.dd_init_mobile(result);
                }
            });
        } else {
            FlowRouter.go('/');
        }
    }
});

FlowRouter.route('/steedos/dingtalk/sso_pc', {
    action: function(params, queryParams) {
        if (!Meteor.userId() && queryParams.corpid) {
            Meteor.call('dingtalk_sso', queryParams.corpid, window.location.href, function(error, result) {
                if (error) {
                    swal("Error!", error.message, "error");
                }
                if (result) {
                    DingtalkManager.dd_init_pc(result);
                }
            });
        } else {
            FlowRouter.go('/');
        }
    }
});