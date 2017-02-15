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
        debugger;
        var target = $(event.currentTarget);
        if(!(target.hasClass("btn-select-opinion"))){
            return;
        }
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
            var index = opinions.indexOf(event.currentTarget.dataset.opinion);
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
            var index = opinions.indexOf(event.currentTarget.dataset.opinion);
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

Template.opinion_modal.onRendered(function(){
    var list = $(".slippylist")[0];
    list.addEventListener('slip:beforereorder', function(event){
        if (/slip-no-reorder/.test(event.target.className)) {
            event.preventDefault();
        }
    }, false);
    list.addEventListener('slip:beforeswipe', function(event){
        // 不做左右方向的移动
        event.preventDefault();
    }, false);
    list.addEventListener('slip:beforewait', function(event){
        //保证class中有instant的才上下移动，否则长按才上下移动
        if (event.target.className.indexOf('instant') >= 0) event.preventDefault();
    }, false);
    list.addEventListener('slip:reorder', function(event){
        if(event.detail.spliceIndex <= 0){
            //不可以元素拖到第一行，因为第一行是添加按钮
            return false;
        }
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
            // 后面的计算要执行减一的原因是顶部有一个item是添加按钮。
            var movedItem = opinions[event.detail.originalIndex-1];
            opinions.splice(event.detail.originalIndex-1, 1); // Remove item from the previous position
            opinions.splice(event.detail.spliceIndex-1, 0, movedItem); // Insert item in the new position

            event.target.parentNode.insertBefore(event.target, event.detail.insertBefore);

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
        return false;
    }, false);
    new Slip(list);
});