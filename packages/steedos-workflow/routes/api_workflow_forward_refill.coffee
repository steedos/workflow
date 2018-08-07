JsonRoutes.add("post", "/api/workflow/forward_refill", (req, res, next) ->
	console.log "=========分发回填=========="
	console.log "req",req?.body

	# 分发的申请单
	forward_ins = req?.body?.instance

	# 原申请单 
	original_ins_id = forward_ins?.distribute_from_instances.pop()
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
		exists_field = original_ins_fields.filter((m)->return (m.type==field.type&&m.code==field.code)||(m.type=='input'&&field.type=='select'&&m.code==field.code))
		if exists_field
			common_fields.push field
	
	common_fields.forEach (field)->
		if forward_ins_values[field.code] && !original_ins_values[field.code]
			original_ins_values[field.code] = forward_ins_values[field.code]
	
	db.instances.update(original_ins_id,{$set:{'values':original_ins_values}})

	JsonRoutes.sendResult res, {
		code: 200,
		data: {
			'success': '成功'
		}
	}
)