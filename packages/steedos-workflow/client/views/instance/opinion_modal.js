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
    }
})

Template.opinion_modal.events({

    'click .btn-select-opinion': function(event, template) {
        var oldVal = $("#suggestion").val();
        var selectedVal = event.target.dataset.opinion;
        selectedVal = selectedVal ? selectedVal : "";
        $("#suggestion").val(oldVal + selectedVal).focus();
        Modal.hide(template);
    },

    'click .btn-new-opinion': function(event, template) {
        Modal.hide(template);

        swal({
            title: t('instance_opinion_input'),
            type: "input",
            showCancelButton: true,
            closeOnConfirm: false,
            confirmButtonText: t('OK'),
            cancelButtonText: t('Cancel'),
            showLoaderOnConfirm: true
        }, function(inputValue) {
            if (inputValue === false){
                Modal.show('opinion_modal');
                return false;
            }
            if (inputValue === "") {
                swal.showInputError(t('instance_opinion_input'));
                return false
            }

            inputValue = inputValue.trim();
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
                    swal.showInputError(t('instance_opinion_exists'));
                    return false;
                }

                opinions.unshift(inputValue);
            } else {
                opinions = [inputValue];
            }

            Meteor.call('setKeyValue', 'flow_opinions', {
                workflow: opinions
            }, function(error, result) {
                Modal.show('opinion_modal');
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

    'click .btn-edit-opinion': function(event, template) {
        Modal.hide(template);
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
            var index = opinions.indexOf(event.target.dataset.opinion);
            if (index > -1) {
                swal({
                    title: t('instance_opinion_edit'),
                    type: "input",
                    inputValue: opinions[index],
                    showCancelButton: true,
                    closeOnConfirm: false,
                    confirmButtonText: t('OK'),
                    cancelButtonText: t('Cancel'),
                    showLoaderOnConfirm: true
                }, function(inputValue) {
                    if (inputValue === false){
                        Modal.show('opinion_modal');
                        return false;
                    }
                    if (inputValue === "") {
                        swal.showInputError(t('instance_opinion_input'));
                        return false
                    }

                    inputValue = inputValue.trim();
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
                        var indexOfOpinions = opinions.indexOf(inputValue);
                        if (indexOfOpinions > -1 && indexOfOpinions != index) {
                            swal.showInputError(t('instance_opinion_exists'));
                            return false;
                        }

                        opinions[index] = inputValue;
                    } else {
                        opinions = [inputValue];
                    }

                    Meteor.call('setKeyValue', 'flow_opinions', {
                        workflow: opinions
                    }, function(error, result) {
                        Modal.show('opinion_modal');
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
                                title: t('instance_opinion_edit_success'),
                                type: "success",
                                closeOnConfirm: true,
                                confirmButtonText: t('OK')
                            });
                        }
                    });

                });
            }
        }
    },

    'click .btn-remove-opinion': function(event, template) {
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
            var index = opinions.indexOf(event.target.dataset.opinion);
            if (index > -1) {
                opinions.splice(index, 1);

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

    'click .btn-moveup-opinion': function(event, template) {
        var selected = event.target.dataset.opinion;
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

    'click .btn-movedown-opinion': function(event, template) {
        var selected = event.target.dataset.opinion;
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
    }
})