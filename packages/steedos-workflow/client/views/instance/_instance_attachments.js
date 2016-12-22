InstanceAttachmentTemplate.helpers = {
    enabled_add_attachment: function() {
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return "display: none;";

        if (InstanceManager.isCC(ins))
            return "display: none;";

        if (Session.get("box") == "draft" || Session.get("box") == "inbox")
            return "";
        else
            return "display: none;";
    },

    attachments: function() {
        var instanceId = Session.get('instanceId');
        if (!instanceId)
            return;

        return cfs.instances.find({
            'metadata.instance': instanceId,
            'metadata.current': true
        }).fetch();
    },

    showAttachments: function(){
        var ins = WorkflowManager.getInstance();
        if (!ins)
            return false;

        var instanceId = Session.get('instanceId');
        if (!instanceId)
            return false;


        var attachments = cfs.instances.find({
            'metadata.instance': instanceId,
            'metadata.current': true
        }).fetch();

        if (Session.get("box") == "draft" || Session.get("box") == "inbox" || attachments.length > 0)
            return true;
        else
            return false;
    },

    _t: function(key){
        return TAPi18n.__(key)
    }

}

if(Meteor.isServer){
    InstanceAttachmentTemplate.helpers._t = function(key){
        locale = Template.instance().view.template.steedosData.locale
        return TAPi18n.__(key, {}, locale)
    }
    InstanceAttachmentTemplate.helpers.enabled_add_attachment = function () {
        return "display: none;"
    };

    InstanceAttachmentTemplate.helpers.attachments = function () {
        var instance = Template.instance().view.template.steedosData.instance;
        var attachments = cfs.instances.find({
            'metadata.instance': instance._id,
            'metadata.current': true
        }).fetch();

        return attachments;
    };

    InstanceAttachmentTemplate.helpers.showAttachments = function () {
        var instance = Template.instance().view.template.steedosData.instance;
        var attachments = cfs.instances.find({
            'metadata.instance': instance._id,
            'metadata.current': true
        }).fetch();

        if(attachments && attachments.length > 0){
            return true;
        }
        return false;
    }
}