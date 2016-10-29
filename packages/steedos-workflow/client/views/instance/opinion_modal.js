Template.opinion_modal.helpers({
    opinions: function() {
        var opinions = [];
        var o = db.steedos_keyvalues.findOne({
            user: Meteor.userId(),
            key: 'flow_opinions',
            'value.workflow': {
                $exists: true
            }
        });
        if (o) {
            opinions = o.value.workflow;
        }
        return opinions;
    },

    flow_comment: function() {
        return Session.get('flow_comment');
    },

    active: function(opinion) {
        return opinion == Session.get('flow_selected_opinion');
    },

    not_selected_opinion: function() {
        return !Session.get('flow_selected_opinion');
    }
})

Template.opinion_modal.events({

    'click .list-group-item': function(event, template) {
        Session.set('flow_selected_opinion', event.target.dataset.opinion);
    },

    'dblclick .list-group-item': function(event, template) {
        var so = event.target.dataset.opinion,
            c = Session.get('flow_comment'),
            new_c;
        new_c = c ? (c + so) : so;

        Session.set('flow_selected_opinion', so);
        Session.set('flow_comment', new_c)
    },

    'click #instance_flow_opinions_to': function(event, template) {
        var so = Session.get('flow_selected_opinion');
        if (so) {
            var c = Session.get('flow_comment'),
                new_c;
            new_c = c ? (c + so) : so;
            Session.set('flow_comment', new_c)
        }
    },

    'click #instance_flow_opinions_plus': function(event, template) {
        Modal.hide(template);

        swal({
            title: t('instance_opinion_input'),
            type: "input",
            showCancelButton: false,
            closeOnConfirm: false,
            confirmButtonText: t('OK'),
            cancelButtonText: t('Cancel')
        }, function(inputValue) {
            if (inputValue === false) return false;
            if (inputValue === "") {
                swal.showInputError(t('instance_opinion_input'));
                return false
            }

            Modal.show('opinion_modal');

            var opinions = [];
            var o = db.steedos_keyvalues.findOne({
                user: Meteor.userId(),
                key: 'flow_opinions',
                'value.workflow': {
                    $exists: true
                }
            });

            if (o) {
                opinions = o.value.workflow;
                // 判断是否已经存在
                if (opinions.includes(inputValue)) {
                    swal({
                        title: t('instance_opinion_exists'),
                        type: "warning",
                        closeOnConfirm: true,
                        confirmButtonText: t('OK')
                    });
                    return false;
                }

                opinions.unshift(inputValue);
            } else {
                opinions = [inputValue];
            }

            Meteor.call('setKeyValue', 'flow_opinions', {
                workflow: opinions
            }, function(error, result) {
                if (error) {
                    swal({
                        title: t('instance_opinion_error'),
                        type: "error",
                        text: error,
                        closeOnConfirm: true,
                        confirmButtonText: t('OK')
                    });
                }

                if (result == true) {
                    swal({
                        title: t('instance_opinion_add_success'),
                        type: "success",
                        closeOnConfirm: true,
                        confirmButtonText: t('OK')
                    });
                }

            });


        });
    },

    'click #instance_flow_opinions_minus': function(event, template) {
        var opinions = [];
        var o = db.steedos_keyvalues.findOne({
            user: Meteor.userId(),
            key: 'flow_opinions',
            'value.workflow': {
                $exists: true
            }
        });
        if (o) {
            opinions = o.value.workflow;
            var index = opinions.indexOf(Session.get('flow_selected_opinion'));
            if (index > -1) {
                opinions.splice(index, 1);

                Meteor.call('setKeyValue', 'flow_opinions', {
                    workflow: opinions
                }, function(error, result) {
                    Session.set('flow_selected_opinion', undefined);

                    if (error) {
                        swal({
                            title: t('instance_opinion_error'),
                            type: "error",
                            text: error,
                            closeOnConfirm: true,
                            confirmButtonText: t('OK')
                        });
                    }

                    if (result == true) {
                        swal({
                            title: t('instance_opinion_remove_success'),
                            type: "success",
                            closeOnConfirm: true,
                            confirmButtonText: t('OK')
                        });
                    }

                });
            }
        }
    },

    'click #instance_flow_opinions_up': function(event, template) {
        var selected = Session.get('flow_selected_opinion');
        var opinions = [];
        var o = db.steedos_keyvalues.findOne({
            user: Meteor.userId(),
            key: 'flow_opinions',
            'value.workflow': {
                $exists: true
            }
        });
        if (o) {
            var opinions = o.value.workflow;
            var index = opinions.indexOf(selected);
            if (index == 0) return;
            var f = opinions[index - 1];
            opinions[index - 1] = selected;
            opinions[index] = f;
            Meteor.call('setKeyValue', 'flow_opinions', {
                workflow: opinions
            }, function(error, result) {

                if (error) {
                    swal({
                        title: "Error!",
                        type: "error",
                        text: error,
                        closeOnConfirm: true,
                        confirmButtonText: t('OK')
                    });
                }

            });
        }
    },

    'click #instance_flow_opinions_down': function(event, template) {
        var selected = Session.get('flow_selected_opinion');
        var opinions = [];
        var o = db.steedos_keyvalues.findOne({
            user: Meteor.userId(),
            key: 'flow_opinions',
            'value.workflow': {
                $exists: true
            }
        });
        if (o) {
            var opinions = o.value.workflow;
            var index = opinions.indexOf(selected);
            if (index == (opinions.length - 1)) return;
            var f = opinions[index + 1];
            opinions[index + 1] = selected;
            opinions[index] = f;
            Meteor.call('setKeyValue', 'flow_opinions', {
                workflow: opinions
            }, function(error, result) {

                if (error) {
                    swal({
                        title: "Error!",
                        type: "error",
                        text: error,
                        closeOnConfirm: true,
                        confirmButtonText: t('OK')
                    });
                }

            });
        }
    },

    'change #instance_flow_comment': function(event, template) {
        Session.set('flow_comment', event.target.value);
    },

    'click #opinion_modal_ok': function(event, template) {
        $("#suggestion").val(Session.get('flow_comment'));
        Modal.hide(template);
    }
})