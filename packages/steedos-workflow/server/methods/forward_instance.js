Meteor.methods({
	forward_instance: function(instance_id, space_id, flow_id, hasSaveInstanceToAttachment, description, isForwardAttachments, selectedUsers, action_type, related, from_approve_id) {
		if (!this.userId)
			return;

		check(instance_id, String);
		check(space_id, String);
		check(flow_id, String);
		check(hasSaveInstanceToAttachment, Boolean);
		check(description, String);
		check(isForwardAttachments, Boolean);
		check(selectedUsers, Array);
		check(action_type, Match.OneOf('forward', 'distribute'));

		if (action_type == "distribute")
			check(from_approve_id, String);

		var ins = db.instances.findOne(instance_id);
		var old_space_id = ins.space;

		var flow = db.flows.findOne(flow_id);

		var space = db.spaces.findOne(space_id);

		if (!ins || !flow || !space) {
			throw new Meteor.Error('params error!', 'record not exists!');
		}

		var forward_users = new Array;
		if (_.isEmpty(selectedUsers)) {
			forward_users = [this.userId];
		} else {
			forward_users = selectedUsers;
		}

		// 校验分发对象是否有分发流程的提交权限
		var no_permission_user_ids = new Array();
		_.each(forward_users, function(uid) {
			var permissions = permissionManager.getFlowPermissions(flow_id, uid);
			if (!permissions.includes("add")) {
				// throw new Meteor.Error('error!', "该申请人没有提交此申请单的权限。")
				no_permission_user_ids.push(uid);
			}
		})
		if (!_.isEmpty(no_permission_user_ids)) {
			var no_permission_users_name = new Array();
			db.users.find({
				_id: {
					$in: no_permission_user_ids
				}
			}, {
				fields: {
					name: 1
				}
			}).forEach(function(u) {
				no_permission_users_name.push(u.name);
			});
			throw new Meteor.Error('no_permission', "该提交人没有提交此申请单的权限。", no_permission_users_name.join(','))
		}

		var new_ins_ids = new Array;

		var current_trace = null;
		if (action_type == "distribute") {
			_.each(ins.traces, function(t) {
				if (!current_trace) {
					_.each(t.approves, function(a) {
						if (!current_trace) {
							if (a._id == from_approve_id)
								current_trace = t;
						}
					})
				}
			})
		} else {
			current_trace = _.last(ins.traces);
		}
		var current_trace_id = current_trace._id;
		var forward_approves = [];
		var current_user_id = this.userId;
		var from_user_name = db.users.findOne(current_user_id, {
			fields: {
				name: 1
			}
		}).name
		var set_obj = new Object;

		// 计算values
		var old_values = ins.values,
			new_values = {};
		var form = db.forms.findOne(flow.form);
		var fields = form.current.fields || [];

		var old_form = db.forms.findOne(ins.form);
		var old_form_version = ins.form_version,
			old_fields = [],
			common_fields = [];

		var select_to_input_fields = [];

		if (old_form.current._id == old_form_version) {
			old_fields = old_form.current.fields;
		} else {
			if (old_form.historys) {
				old_form.historys.forEach(function(h) {
					if (h._id == old_form_version)
						old_fields = h.fields;
				})
			}
		}

		fields.forEach(function(field) {
			var exists_field = _.find(old_fields, function(f) {
				return f.type == field.type && f.code == field.code;
			})
			if (exists_field)
				common_fields.push(field);
			var select_input_field = _.find(old_fields, function(f) {
				return f.type == 'select' && field.type == 'input' && f.code == field.code;
			})
			if (select_input_field)
				select_to_input_fields.push(select_input_field);
		})

		select_to_input_fields.forEach(function(field) {
			if (old_values[field.code]) {
				new_values[field.code] = old_values[field.code];
			}
		})

		common_fields.forEach(function(field) {
			if (field.type == 'section') {
				if (field.fields) {
					field.fields.forEach(function(f) {
						// 跨工作区转发不复制选人选组
						if (['group', 'user'].includes(f.type) && old_space_id != space_id) {
							return;
						}
						var key = f.code;
						var old_v = old_values[key];
						if (old_v) {
							// 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
							if (f.type == 'select' || f.type == 'radio') {
								var options = f.options.split('\n');
								if (!options.includes(old_v))
									return;
							}

							if (f.type == 'multiSelect') {
								var options = f.options.split('\n');
								var old_multiSelected = old_v.split(',');
								var new_multiSelected = _.intersection(options, old_multiSelected);
								old_v = new_multiSelected.join(',');
							}

							new_values[key] = old_v;
						}
					})
				}
			} else if (field.type == 'table') {
				if (!_.isEmpty(old_values[field.code])) {
					new_values[field.code] = new Array;
					old_values[field.code].forEach(function(old_table_row_values) {
						var new_table_row_values = {};

						if (!_.isEmpty(field.fields)) {
							field.fields.forEach(function(f) {
								// 跨工作区转发不复制选人选组
								if (['group', 'user'].includes(f.type) && old_space_id != space_id) {
									return;
								}
								var key = f.code;
								var old_v = old_table_row_values[key];
								if (old_v) {
									// 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
									if (f.type == 'select' || f.type == 'radio') {
										var options = f.options.split('\n');
										if (!options.includes(old_v))
											return;
									}

									if (f.type == 'multiSelect') {
										var options = f.options.split('\n');
										var old_multiSelected = old_v.split(',');
										var new_multiSelected = _.intersection(options, old_multiSelected);
										old_v = new_multiSelected.join(',');
									}

									new_table_row_values[key] = old_v;
								}
							})
						}

						if (!_.isEmpty(new_table_row_values)) {
							new_values[field.code].push(new_table_row_values);
						}
					})
				}
			} else {
				// 跨工作区转发不复制选人选组
				if (['group', 'user'].includes(field.type) && old_space_id != space_id) {
					return;
				}
				var key = field.code;
				var old_v = old_values[key];
				if (old_v) {
					// 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
					if (field.type == 'select' || field.type == 'radio') {
						var options = field.options.split('\n');
						if (!options.includes(old_v))
							return;
					}

					if (field.type == 'multiSelect') {
						var options = field.options.split('\n');
						var old_multiSelected = old_v.split(',');
						var new_multiSelected = _.intersection(options, old_multiSelected);
						old_v = new_multiSelected.join(',');
					}

					new_values[key] = old_v;
				}
			}

		})

		// 计算申请单标题
		var instance_name = "";
		var name_forumla = form.current.name_forumla;
		if (name_forumla) {
			var iscript = name_forumla.replace(/\{/g, "(new_values['").replace(/\}/g, "'] || '')");
			var rev = eval(iscript);
			instance_name = rev || flow.name;
		} else {
			instance_name = flow.name;
		}

		// instance中记录当前步骤名称 #1314
		var start_step = _.find(flow.current.steps, function (step){
			return step.step_type == 'start';
			}
		)

		// 新建申请单时，instances记录流程名称、流程分类名称 #1313
		var category_name = "";
		if (form.category) {
			var category = uuflowManager.getCategory(form.category);
			if (category)
				category_name = category.name;
		}

		_.each(forward_users, function(user_id) {

			var user_info = db.users.findOne(user_id);

			var space_user = db.space_users.findOne({
				space: space_id,
				user: user_id
			});
			var space_user_org_info = db.organizations.findOne(space_user.organization);

			var now = new Date();
			var ins_obj = {};

			ins_obj._id = db.instances._makeNewID();
			ins_obj.space = space_id;
			ins_obj.flow = flow_id;
			ins_obj.flow_version = flow.current._id;
			ins_obj.form = flow.form;
			ins_obj.form_version = flow.current.form_version;
			ins_obj.name = instance_name;
			ins_obj.submitter = user_id;
			ins_obj.submitter_name = user_info.name;
			ins_obj.applicant = user_id;
			ins_obj.applicant_name = user_info.name;
			ins_obj.applicant_organization = space_user.organization;
			ins_obj.applicant_organization_name = space_user_org_info.name;
			ins_obj.applicant_organization_fullname = space_user_org_info.fullname;
			ins_obj.state = "draft";
			ins_obj.code = "";
			ins_obj.is_archived = false;
			ins_obj.is_deleted = false;
			ins_obj.created = now;
			ins_obj.created_by = current_user_id;
			ins_obj.modified = now;
			ins_obj.modified_by = current_user_id;
			ins_obj.inbox_users = [user_id];
			ins_obj.values = new_values;
			if (action_type == 'distribute') {
				// 解决多次分发看不到正文、附件问题
				if (ins.distribute_from_instance) {
					ins_obj.distribute_from_instance = ins.distribute_from_instance;
				} else {
					ins_obj.distribute_from_instance = instance_id;
				}
				ins_obj.distribute_from_instances = _.clone(ins.distribute_from_instances) || [];
				ins_obj.distribute_from_instances.push(instance_id);

				if (related) {
					ins_obj.related_instances = [instance_id]
				}

			} else if (action_type == 'forward') {
				ins_obj.forward_from_instance = instance_id
			}

			// 新建Trace
			var trace_obj = {};
			trace_obj._id = new Mongo.ObjectID()._str;
			trace_obj.instance = ins_obj._id;
			trace_obj.is_finished = false;

			// 当前最新版flow中开始节点的step_id
			var step_id, step_name, can_edit_main_attach, can_edit_normal_attach;
			flow.current.steps.forEach(function(step) {
				if (step.step_type == "start") {
					step_id = step._id;
					step_name = step.name;
					can_edit_main_attach = step.can_edit_main_attach;
					can_edit_normal_attach = step.can_edit_normal_attach;
				}
			})
			trace_obj.step = step_id;
			trace_obj.start_date = now;
			trace_obj.name = step_name;

			// 新建Approve
			var appr_obj = {};
			appr_obj._id = new Mongo.ObjectID()._str;
			appr_obj.instance = ins_obj._id;
			appr_obj.trace = trace_obj._id;
			appr_obj.is_finished = false;
			appr_obj.user = user_id;
			appr_obj.user_name = user_info.name;
			appr_obj.handler = user_id;
			appr_obj.handler_name = user_info.name;
			appr_obj.handler_organization = space_user.organization;
			appr_obj.handler_organization_name = space_user_org_info.name;
			appr_obj.handler_organization_fullname = space_user_org_info.fullname;
			appr_obj.type = "draft";
			appr_obj.start_date = now;
			appr_obj.read_date = now;
			appr_obj.is_read = false;
			appr_obj.is_error = false;

			appr_obj.values = new_values;

			trace_obj.approves = [appr_obj];
			ins_obj.traces = [trace_obj];

			if (flow.auto_remind == true)
				ins_obj.auto_remind = true;

			ins_obj.current_step_name = start_step.name;

			ins_obj.flow_name = flow.name;
			if (category_name)
				ins_obj.category_name = category.name;

			new_ins_id = db.instances.insert(ins_obj);

			// 复制附件
			var collection = cfs.instances;

			//将原表单内容存储为第一个附件
			if (hasSaveInstanceToAttachment) {
				// try {

				instanceHtml = InstanceReadOnlyTemplate.getInstanceHtml(user_info, space_id, ins, {
					absolute: true
				})
				var instanceFile = new FS.File();
				instanceFile.attachData(Buffer.from(instanceHtml, "utf-8"), {
					type: "text/html"
				}, function(error) {
					if (error) {
						throw new Meteor.Error(error.error, error.reason);
					}

					instanceFile.name(ins.name + ".html");
					instanceFile.size(instanceHtml.length);

					var metadata = {
						owner: user_id,
						owner_name: user_info.name,
						space: space_id,
						instance: new_ins_id,
						approve: appr_obj._id,
						current: true
					};
					instanceFile.metadata = metadata;
					var fileObj = collection.insert(instanceFile);
					fileObj.update({
						$set: {
							'metadata.parent': fileObj._id
						}
					})
				})

				// } catch (e) {
				//     console.error(e);
				// }
			}

			if (isForwardAttachments && action_type == 'forward') {
				var files = collection.find({
					'metadata.instance': instance_id,
					'metadata.current': true
				});
				files.forEach(function(f) {
					// 判断新的流程开始节点是否有编辑正文和编辑附件权限
					if (f.metadata.main == true) {
						if (can_edit_main_attach != true && can_edit_normal_attach != true)
							return;
					} else {
						if (can_edit_normal_attach != true)
							return;
					}

					var newFile = new FS.File();
					newFile.attachData(f.createReadStream('instances'), {
						type: f.original.type
					}, function(err) {
						if (err) {
							throw new Meteor.Error(err.error, err.reason);
						}
						newFile.name(f.name());
						newFile.size(f.size());
						var metadata = {
							owner: user_id,
							owner_name: user_info.name,
							space: space_id,
							instance: new_ins_id,
							approve: appr_obj._id,
							current: true
						};
						if (f.metadata.main == true && can_edit_main_attach == true) {
							metadata.main = true;
						}
						newFile.metadata = metadata;
						var fileObj = collection.insert(newFile);
						fileObj.update({
							$set: {
								'metadata.parent': fileObj._id
							}
						})
					})

				})
			}

			// 给当前的申请单增加转发记录
			var appr = {
				'_id': new Mongo.ObjectID()._str,
				'instance': instance_id,
				'trace': current_trace_id,
				'is_finished': true,
				'user': user_id,
				'user_name': user_info.name,
				'handler': user_id,
				'handler_name': user_info.name,
				'handler_organization': space_user.organization,
				'handler_organization_name': space_user_org_info.name,
				'handler_organization_fullname': space_user_org_info.fullname,
				'type': action_type,
				'start_date': new Date(),
				'finish_date': new Date(),
				'is_read': false,
				'judge': 'submitted',
				'from_user': current_user_id,
				'from_user_name': from_user_name,
				'forward_space': space_id,
				'forward_instance': new_ins_id,
				'description': description,
				'from_approve_id': from_approve_id
			};

			forward_approves.push(appr);

			new_ins_ids.push(new_ins_id);
			pushManager.send_message_to_specifyUser("current_user", user_id);
		})

		set_obj.modified = new Date();
		set_obj.modified_by = current_user_id;
		var r = db.instances.update({
			_id: instance_id,
			"traces._id": current_trace_id
		}, {
			$set: set_obj,
			$addToSet: {
				'traces.$.approves': {
					$each: forward_approves
				}
			}
		});

		if (r) {
			_.each(current_trace.approves, function(a, idx) {
				if (a._id == from_approve_id) {
					var update_read = {};
					update_read["traces.$.approves." + idx + ".read_date"] = new Date();
					db.instances.update({
						_id: instance_id,
						"traces._id": current_trace_id
					}, {
						$set: update_read
					});
				}
			})

		}

		return new_ins_ids;
	},


	forward_remove: function(instance_id, trace_id, approve_id) {
		check(instance_id, String);
		check(trace_id, String);
		check(approve_id, String);

		var ins = db.instances.findOne(instance_id);

		if (!ins) {
			throw new Meteor.Error('params error!', 'record not exists!');
		}

		var trace = _.find(ins.traces, function(t) {
			return t._id == trace_id;
		});

		var approve = _.find(trace.approves, function(appr) {
			return appr._id == approve_id;
		})

		var hasAdminPermission = WorkflowManager.hasFlowAdminPermission(ins.flow, ins.space, this.userId)

		if (!approve || !['forward', 'distribute'].includes(approve.type) || !approve.forward_instance) {
			if (!hasAdminPermission) {
				if (approve.from_user != this.userId)
					throw new Meteor.Error('error!', 'instance_forward_cannot_cancel');
			}
		}

		var forward_instance_id = approve.forward_instance;
		var forward_instance = db.instances.findOne(forward_instance_id);
		if (forward_instance) {
			if (forward_instance.state != "draft") {
				if (!hasAdminPermission)
					throw new Meteor.Error('error!', 'instance_forward_instance_state_changed');
			}
			var inbox_users = forward_instance.inbox_users || [];

			forward_instance.deleted = new Date();
			forward_instance.deleted_by = this.userId;
			var deleted_forward_instance_id = db.deleted_instances.insert(forward_instance);
			if (deleted_forward_instance_id) {
				db.instances.remove({
					_id: forward_instance_id
				});

				// 删除申请单后重新计算inbox_users的badge
				_.each(inbox_users, function(u_id) {
					pushManager.send_message_to_specifyUser("current_user", u_id);
				})
			}
		}

		var set_obj = new Object;
		set_obj.modified = new Date();
		set_obj.modified_by = this.userId;

		_.each(trace.approves, function(appr, idx) {
			if (appr._id == approve_id) {
				set_obj['traces.$.approves.' + idx + '.judge'] = 'terminated';
				set_obj['traces.$.approves.' + idx + '.is_finished'] = true;
				set_obj['traces.$.approves.' + idx + '.finish_date'] = new Date();
				set_obj['traces.$.approves.' + idx + '.is_read'] = true;
				set_obj['traces.$.approves.' + idx + '.read_date'] = new Date();
			}
		})

		db.instances.update({
			_id: instance_id,
			"traces._id": trace_id
		}, {
			$set: set_obj
		})

		return true;
	},

	cancelDistribute: function(instance_id, approve_ids) {
		check(instance_id, String)
		check(approve_ids, Array)

		var ins = db.instances.findOne(instance_id)

		if (!ins) {
			throw new Meteor.Error('params error!', 'record not exists!')
		}

		userId = this.userId

		var hasAdminPermission = WorkflowManager.hasFlowAdminPermission(ins.flow, ins.space, userId)

		_.each(ins.traces, function(t) {
			if (t.approves) {
				var exists = false
				var set_obj = new Object
				_.each(t.approves, function(a, idx) {
					if (approve_ids.includes(a._id) && (a.from_user == userId || hasAdminPermission) && 'distribute' == a.type && a.forward_instance) {
						var forward_instance_id = a.forward_instance
						var forward_instance = db.instances.findOne(forward_instance_id)
						if (forward_instance) {
							if (forward_instance.state != "draft") {
								return
							}
							var inbox_users = forward_instance.inbox_users || []

							forward_instance.deleted = new Date()
							forward_instance.deleted_by = userId
							var deleted_forward_instance_id = db.deleted_instances.insert(forward_instance)
							if (deleted_forward_instance_id) {
								db.instances.remove({
									_id: forward_instance_id
								})

								// 删除申请单后重新计算inbox_users的badge
								_.each(inbox_users, function(u_id) {
									pushManager.send_message_to_specifyUser("current_user", u_id)
								})
							}

							set_obj['traces.$.approves.' + idx + '.judge'] = 'terminated'
							set_obj['traces.$.approves.' + idx + '.is_finished'] = true
							set_obj['traces.$.approves.' + idx + '.finish_date'] = new Date()
							set_obj['traces.$.approves.' + idx + '.is_read'] = true
							set_obj['traces.$.approves.' + idx + '.read_date'] = new Date()
						}

						exists = true
					}
				})

				if (!exists)
					return

				set_obj.modified = new Date()
				set_obj.modified_by = userId

				db.instances.update({
					_id: instance_id,
					"traces._id": t._id
				}, {
					$set: set_obj
				})
			}
		})

		return true
	}


})
