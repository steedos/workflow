JsonRoutes.add("post", "/api/workflow/forward_refill", (req, res, next) ->
	console.log "=========分发回填=========="
	# console.log "req",req?.body?.instance

	# 分发的申请单
	forward_ins = req?.body?.instance

	if forward_ins?.state == "completed" && forward_ins?.distribute_from_instances?.length>0
		# 原申请单 
		original_ins_id = _.last forward_ins?.distribute_from_instances
		original_ins = db.instances.findOne(original_ins_id)

		# values
		forward_ins_values = forward_ins?.values
		original_ins_values = original_ins?.values
		
		# 分发的申请单字段
		forward_ins_fields = []
		forward_ins_form = db.forms.findOne(forward_ins?.form)
		# 根据forms表找到对应的版本，赋值fields
		if forward_ins?.form_version == forward_ins_form?.current?._id
			forward_ins_fields = forward_ins_form?.current?.fields
		else
			if forward_ins_form?.historys?.length > 0
				forward_ins_form.historys.forEach (fh)->
					if forward_ins?.form_version == fh._id
						forward_ins_fields = fh.fields

		# 原申请单字段
		original_ins_fields = []
		original_ins_form = db.forms.findOne(original_ins?.form)
		# 根据forms表找到对应的版本，赋值fields
		if original_ins?.form_version == original_ins_form.current._id
			original_ins_fields = original_ins_form?.current?.fields
		else
			if original_ins_form?.historys?.length > 0
				original_ins_form.historys.forEach (oh)->
					if original_ins?.form_version == oh._id
						original_ins_fields = oh.fields
		
		# 共有字段
		common_fields = []

		forward_ins_fields.forEach (field)->
			exists_field = original_ins_fields.filter((m)->return m.type==field.type&&m.code==field.code)
			if exists_field && exists_field.length>0
				# console.log "exists_field",exists_field
				common_fields.push field
		
		common_fields.forEach (field)->
			if forward_ins_values[field.code] && !original_ins_values[field.code]
				original_ins_values[field.code] = forward_ins_values[field.code]

		console.log "=============="
		# console.log common_fields
		
		# 更新步骤的值
		traces = original_ins?.traces
		trace = traces[traces.length-1]
		approves = trace?.approves
		
		approves?.forEach (approve) ->
			values = approve?.values || {}
			console.log "原始的值",values
			common_fields.forEach (field)->
				if !values.hasOwnProperty(field.code)
					values[field.code] = forward_ins_values[field.code]
		
		trace.approves = approves

		traces[traces.length-1] = trace
				
		console.log "========最新approves========"
		console.log traces[traces.length-1]?.approves

		db.instances.update(original_ins_id,{
			$set:{
				'traces':traces
				}
			})

		JsonRoutes.sendResult res, {
			code: 200,
			data: {
				'success': '成功'
			}
		}
	else
		JsonRoutes.sendResult res, {
			code: 200,
			data: {
				'success': '申请单未结束'
			}
		}
)