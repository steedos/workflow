JsonRoutes.add 'post', '/api/workflow/forward', (req, res, next) ->
	try
		current_user_info = uuflowManager.check_authorization(req)
		current_user_id = current_user_info._id

		hashData = req.body

		instance_id = hashData.instance_id
		space_id = hashData.space_id
		flow_id = hashData.flow_id
		hasSaveInstanceToAttachment = hashData.hasSaveInstanceToAttachment
		description = hashData.description
		isForwardAttachments = hashData.isForwardAttachments
		selectedUsers = hashData.selectedUsers
		action_type = hashData.action_type
		related = hashData.related
		from_approve_id = hashData.from_approve_id

		check instance_id, String
		check space_id, String
		check flow_id, String
		check hasSaveInstanceToAttachment, Boolean
		check description, String
		check isForwardAttachments, Boolean
		check selectedUsers, Array
		check action_type, Match.OneOf('forward', 'distribute')
		if action_type == 'distribute'
			check from_approve_id, String

		ins = db.instances.findOne(instance_id)
		old_space_id = ins.space
		flow = db.flows.findOne(flow_id)
		space = db.spaces.findOne(space_id)
		if !ins or !flow or !space
			throw new (Meteor.Error)('params error!', 'record not exists!')
		forward_users = new Array
		if _.isEmpty(selectedUsers)
			forward_users = [ current_user_id ]
		else
			forward_users = selectedUsers
		# 校验分发对象是否有分发流程的提交权限
		no_permission_user_ids = new Array
		_.each forward_users, (uid) ->
			permissions = permissionManager.getFlowPermissions(flow_id, uid)
			if !permissions.includes('add')
				# throw new Meteor.Error('error!', "该申请人没有提交此申请单的权限。")
				no_permission_user_ids.push uid
			return
		if !_.isEmpty(no_permission_user_ids)
			no_permission_users_name = new Array
			db.users.find({ _id: $in: no_permission_user_ids }, fields: name: 1).forEach (u) ->
				no_permission_users_name.push u.name
				return
			throw new (Meteor.Error)('no_permission', '该提交人没有提交此申请单的权限。', no_permission_users_name.join(','))
		new_ins_ids = new Array
		current_trace = null
		if action_type == 'distribute'
			_.each ins.traces, (t) ->
				if !current_trace
					_.each t.approves, (a) ->
						if !current_trace
							if a._id == from_approve_id
								current_trace = t
						return
				return
		else
			current_trace = _.last(ins.traces)
		current_trace_id = current_trace._id
		forward_approves = []
		from_user_name = db.users.findOne(current_user_id, fields: name: 1).name
		set_obj = new Object
		# 计算values
		old_values = ins.values
		new_values = {}
		form = db.forms.findOne(flow.form)
		fields = form.current.fields or []
		old_form = db.forms.findOne(ins.form)
		old_form_version = ins.form_version
		old_fields = []
		common_fields = []
		select_to_input_fields = []
		if old_form.current._id == old_form_version
			old_fields = old_form.current.fields
		else
			if old_form.historys
				old_form.historys.forEach (h) ->
					if h._id == old_form_version
						old_fields = h.fields
					return
		fields.forEach (field) ->
			exists_field = _.find(old_fields, (f) ->
				f.type == field.type and f.code == field.code
			)
			if exists_field
				common_fields.push field
			select_input_field = _.find(old_fields, (f) ->
				f.type == 'select' and field.type == 'input' and f.code == field.code
			)
			if select_input_field
				select_to_input_fields.push select_input_field
			return
		select_to_input_fields.forEach (field) ->
			if old_values[field.code]
				new_values[field.code] = old_values[field.code]
			return
		common_fields.forEach (field) ->
			`var options`
			if field.type == 'section'
				if field.fields
					field.fields.forEach (f) ->
						`var options`
						# 跨工作区转发不复制选人选组
						if [
								'group'
								'user'
							].includes(f.type) and old_space_id != space_id
							return
						key = f.code
						old_v = old_values[key]
						if old_v
							# 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
							if f.type == 'select' or f.type == 'radio'
								options = f.options.split('\n')
								if !options.includes(old_v)
									return
							if f.type == 'multiSelect'
								options = f.options.split('\n')
								old_multiSelected = old_v.split(',')
								new_multiSelected = _.intersection(options, old_multiSelected)
								old_v = new_multiSelected.join(',')
							new_values[key] = old_v
						return
			else if field.type == 'table'
				if !_.isEmpty(old_values[field.code])
					new_values[field.code] = new Array
					old_values[field.code].forEach (old_table_row_values) ->
						new_table_row_values = {}
						if !_.isEmpty(field.fields)
							field.fields.forEach (f) ->
								`var options`
								# 跨工作区转发不复制选人选组
								if [
										'group'
										'user'
									].includes(f.type) and old_space_id != space_id
									return
								key = f.code
								old_v = old_table_row_values[key]
								if old_v
									# 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
									if f.type == 'select' or f.type == 'radio'
										options = f.options.split('\n')
										if !options.includes(old_v)
											return
									if f.type == 'multiSelect'
										options = f.options.split('\n')
										old_multiSelected = old_v.split(',')
										new_multiSelected = _.intersection(options, old_multiSelected)
										old_v = new_multiSelected.join(',')
									new_table_row_values[key] = old_v
								return
						if !_.isEmpty(new_table_row_values)
							new_values[field.code].push new_table_row_values
						return
			else
				# 跨工作区转发不复制选人选组
				if [
						'group'
						'user'
					].includes(field.type) and old_space_id != space_id
					return
				key = field.code
				old_v = old_values[key]
				if old_v
					# 校验 单选，多选，下拉框 字段值是否在新表单对应字段的可选值范围内
					if field.type == 'select' or field.type == 'radio'
						options = field.options.split('\n')
						if !options.includes(old_v)
							return
					if field.type == 'multiSelect'
						options = field.options.split('\n')
						old_multiSelected = old_v.split(',')
						new_multiSelected = _.intersection(options, old_multiSelected)
						old_v = new_multiSelected.join(',')
					new_values[key] = old_v
			return
		#如果是分发，则value中的record_need、FONDSID不需要分发到新申请单中
		if action_type == 'distribute'
			delete new_values.record_need
			delete new_values.FONDSID
		# 计算申请单标题
		instance_name = ''
		name_forumla = form.current.name_forumla
		if name_forumla
			iscript = name_forumla.replace(/\{/g, '(new_values[\'').replace(/\}/g, '\'] || \'\')')
			rev = eval(iscript)
			instance_name = rev or flow.name
		else
			instance_name = flow.name
		# instance中记录当前步骤名称 #1314
		start_step = _.find(flow.current.steps, (step) ->
			step.step_type == 'start'
		)
		# 新建申请单时，instances记录流程名称、流程分类名称 #1313
		category_name = ''
		if form.category
			category = uuflowManager.getCategory(form.category)
			if category
				category_name = category.name
		_.each forward_users, (user_id) ->
			user_info = db.users.findOne(user_id)
			space_user = db.space_users.findOne({
				space: space_id
				user: user_id
			}, fields: organization: 1)
			space_user_org_info = db.organizations.findOne({ _id: space_user.organization }, fields:
				name: 1
				fullname: 1)
			now = new Date
			ins_obj = {}
			ins_obj._id = db.instances._makeNewID()
			ins_obj.space = space_id
			ins_obj.flow = flow_id
			ins_obj.flow_version = flow.current._id
			ins_obj.form = flow.form
			ins_obj.form_version = flow.current.form_version
			ins_obj.name = instance_name
			ins_obj.submitter = user_id
			ins_obj.submitter_name = user_info.name
			ins_obj.applicant = user_id
			ins_obj.applicant_name = user_info.name
			ins_obj.applicant_organization = space_user.organization
			ins_obj.applicant_organization_name = space_user_org_info.name
			ins_obj.applicant_organization_fullname = space_user_org_info.fullname
			ins_obj.state = 'draft'
			ins_obj.code = ''
			ins_obj.is_archived = false
			ins_obj.is_deleted = false
			ins_obj.created = now
			ins_obj.created_by = current_user_id
			ins_obj.modified = now
			ins_obj.modified_by = current_user_id
			ins_obj.inbox_users = [ user_id ]
			ins_obj.values = new_values
			if action_type == 'distribute'
				# 解决多次分发看不到正文、附件问题
				if ins.distribute_from_instance
					ins_obj.distribute_from_instance = ins.distribute_from_instance
				else
					ins_obj.distribute_from_instance = instance_id
				ins_obj.distribute_from_instances = _.clone(ins.distribute_from_instances) or []
				ins_obj.distribute_from_instances.push instance_id
				if related
					ins_obj.related_instances = [ instance_id ]
			else if action_type == 'forward'
				ins_obj.forward_from_instance = instance_id
			# 新建Trace
			trace_obj = {}
			trace_obj._id = (new (Mongo.ObjectID))._str
			trace_obj.instance = ins_obj._id
			trace_obj.is_finished = false
			# 当前最新版flow中开始节点的step_id
			step_id = undefined
			step_name = undefined
			can_edit_main_attach = undefined
			can_edit_normal_attach = undefined
			flow.current.steps.forEach (step) ->
				if step.step_type == 'start'
					step_id = step._id
					step_name = step.name
					can_edit_main_attach = step.can_edit_main_attach
					can_edit_normal_attach = step.can_edit_normal_attach
				return
			trace_obj.step = step_id
			trace_obj.start_date = now
			trace_obj.name = step_name
			# 新建Approve
			appr_obj = {}
			appr_obj._id = (new (Mongo.ObjectID))._str
			appr_obj.instance = ins_obj._id
			appr_obj.trace = trace_obj._id
			appr_obj.is_finished = false
			appr_obj.user = user_id
			appr_obj.user_name = user_info.name
			appr_obj.handler = user_id
			appr_obj.handler_name = user_info.name
			appr_obj.handler_organization = space_user.organization
			appr_obj.handler_organization_name = space_user_org_info.name
			appr_obj.handler_organization_fullname = space_user_org_info.fullname
			appr_obj.type = 'draft'
			appr_obj.start_date = now
			appr_obj.read_date = now
			appr_obj.is_read = false
			appr_obj.is_error = false
			appr_obj.values = new_values
			trace_obj.approves = [ appr_obj ]
			ins_obj.traces = [ trace_obj ]
			if flow.auto_remind == true
				ins_obj.auto_remind = true
			ins_obj.current_step_name = start_step.name
			ins_obj.flow_name = flow.name
			if category_name
				ins_obj.category_name = category.name
			new_ins_id = db.instances.insert(ins_obj)
			# 复制附件
			collection = cfs.instances
			#将原表单内容存储为第一个附件
			if hasSaveInstanceToAttachment
				# try {
				instanceHtml = InstanceReadOnlyTemplate.getInstanceHtml(user_info, space_id, ins, absolute: true)
				instanceFile = new (FS.File)
				instanceFile.attachData Buffer.from(instanceHtml, 'utf-8'), { type: 'text/html' }, (error) ->
					if error
						throw new (Meteor.Error)(error.error, error.reason)
					instanceFile.name ins.name + '.html'
					instanceFile.size instanceHtml.length
					metadata =
						owner: user_id
						owner_name: user_info.name
						space: space_id
						instance: new_ins_id
						approve: appr_obj._id
						current: true
					instanceFile.metadata = metadata
					fileObj = collection.insert(instanceFile)
					fileObj.update $set: 'metadata.parent': fileObj._id
					return
				# } catch (e) {
				#     console.error(e);
				# }
			if isForwardAttachments and action_type == 'forward'
				files = collection.find(
					'metadata.instance': instance_id
					'metadata.current': true)
				files.forEach (f) ->
					# 判断新的流程开始节点是否有编辑正文和编辑附件权限
					if f.metadata.main == true
						if can_edit_main_attach != true and can_edit_normal_attach != true
							return
					else
						if can_edit_normal_attach != true
							return
					newFile = new (FS.File)
					newFile.attachData f.createReadStream('instances'), { type: f.original.type }, (err) ->
						if err
							throw new (Meteor.Error)(err.error, err.reason)
						newFile.name f.name()
						newFile.size f.size()
						metadata =
							owner: user_id
							owner_name: user_info.name
							space: space_id
							instance: new_ins_id
							approve: appr_obj._id
							current: true
						if f.metadata.main == true and can_edit_main_attach == true
							metadata.main = true
						newFile.metadata = metadata
						fileObj = collection.insert(newFile)
						fileObj.update $set: 'metadata.parent': fileObj._id
						return
					return
			# 给当前的申请单增加转发记录
			appr =
				'_id': (new (Mongo.ObjectID))._str
				'instance': instance_id
				'trace': current_trace_id
				'is_finished': true
				'user': user_id
				'user_name': user_info.name
				'handler': user_id
				'handler_name': user_info.name
				'handler_organization': space_user.organization
				'handler_organization_name': space_user_org_info.name
				'handler_organization_fullname': space_user_org_info.fullname
				'type': action_type
				'start_date': new Date
				'finish_date': new Date
				'is_read': false
				'judge': 'submitted'
				'from_user': current_user_id
				'from_user_name': from_user_name
				'forward_space': space_id
				'forward_instance': new_ins_id
				'description': description
				'from_approve_id': from_approve_id
			forward_approves.push appr
			new_ins_ids.push new_ins_id
			pushManager.send_message_to_specifyUser 'current_user', user_id
			return
		set_obj.modified = new Date
		set_obj.modified_by = current_user_id
		r = db.instances.update({
			_id: instance_id
			'traces._id': current_trace_id
		},
			$set: set_obj
			$addToSet: 'traces.$.approves': $each: forward_approves)
		if r
			_.each current_trace.approves, (a, idx) ->
				if a._id == from_approve_id
					update_read = {}
					update_read['traces.$.approves.' + idx + '.read_date'] = new Date
					db.instances.update {
						_id: instance_id
						'traces._id': current_trace_id
					}, $set: update_read
				return

		JsonRoutes.sendResult res,
				code: 200
				data: {}
	catch e
		console.error e.stack
		JsonRoutes.sendResult res,
			code: 200
			data: { errors: [e] }

