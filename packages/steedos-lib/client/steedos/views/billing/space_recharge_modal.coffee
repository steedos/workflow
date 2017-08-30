Template.space_recharge_modal.onRendered ()->
	$("#space_recharge_end_date").datetimepicker({
		format: "YYYY-MM-DD",
		locale: Session.get("TAPi18n::loaded_lang")
	})


Template.space_recharge_modal.helpers
	modules: ()->
		return db.modules.find()

	is_paid_module: (name)->
		s = db.spaces.findOne(Session.get('spaceId'))
		if s.modules and s.modules.includes(name)
			return true
		return false

	end_date: ()->
		m = moment()
		m.year(m.year()+1)
		e = m.format('YYYY-MM-DD')
		s = db.spaces.findOne(Session.get('spaceId'))
		if s.end_date
			e = moment(s.end_date).format('YYYY-MM-DD')

		return e


Template.space_recharge_modal.events
	'click #space_recharge_generate_qrcode': (event, template)->
		fee_value = 0

		now = new Date
		end_date_str = $('#space_recharge_end_date').val()
		end_date = new Date(end_date_str)

		if end_date <= now
			toastr.error "购买日期不能小于当前日期"
			$('#space_recharge_fee')[0].value = ""
			return

		months = (end_date - now)/(1000*3600*24*30) #一个月按30天算

		user_count = $('#space_recharge_user_count')[0].value.to_integer() || 0

		space = db.spaces.findOne(Session.get('spaceId'))
		space_modules = space.modules || []

		listprices = 0
		_.each $('#space_recharge_modules input'), (m)->
			if m.checked and not space_modules.includes(m.value)
				space_modules.push m.value

		_.each space_modules, (sm)->
			module = db.modules.findOne({name: sm})
			if module and module.listprice
				listprices += module.listprice

		if space.is_paid


			if space_modules.length > 0 and listprices > 0 and user_count > 0 and months > 0
				fee_value = listprices * (20/3) * user_count * months
			else
				return
		else
			if user_count < Session.get('space_user_count')
				toastr.error "购买用户数不能小于工作区当前用户数：#{Session.get('space_user_count')}"
				$('#space_recharge_fee')[0].value = ""
				return
		
			if space_modules.length > 0 and listprices > 0 and user_count > 0 and months > 0
				fee_value = listprices * (20/3) * user_count * months
			else
				return

		if fee_value <= 0
			$('#space_recharge_fee')[0].value = ""
			return
		total_fee = 100 * fee_value.toFixed().to_integer()
		new_id = db.billing_pay_records._makeNewID() 

		$("body").addClass("loading")

		Meteor.call 'billing_recharge', total_fee, Session.get('spaceId'), new_id, space_modules, end_date_str, user_count, (err, result)->
			if err
				$("body").removeClass("loading")
				console.log err
				toastr.error(err.reason)
			if result
				data = new Object
				data._id = new_id
				Modal.allowMultiple = true
				Modal.show('space_recharge_qrcode_modal', data)

	'change #space_recharge_modules input,#space_recharge_end_date': (event, template)->
		console.log "1"
		$('#space_recharge_user_count').trigger('input')

	'input #space_recharge_user_count': (event, template)->
		console.log "2"
		now = new Date
		end_date = new Date($('#space_recharge_end_date').val())

		if end_date <= now
			toastr.error "购买日期不能小于当前日期"
			$('#space_recharge_fee')[0].value = ""
			return

		months = (end_date - now)/(1000*3600*24*30) #一个月按30天算

		user_count = $('#space_recharge_user_count')[0].value.to_integer() || 0

		space = db.spaces.findOne(Session.get('spaceId'))
		space_modules = space.modules || []

		listprices = 0
		_.each $('#space_recharge_modules input'), (m)->
			if m.checked and not space_modules.includes(m.value)
				space_modules.push m.value

		_.each space_modules, (sm)->
			module = db.modules.findOne({name: sm})
			if module and module.listprice
				listprices += module.listprice

		if space.is_paid


			if space_modules.length > 0 and listprices > 0 and user_count > 0 and months > 0
				space_recharge_fee = listprices * (20/3) * user_count * months
				$('#space_recharge_fee')[0].value = space_recharge_fee.toFixed()
			else
				$('#space_recharge_fee')[0].value = ""
		else
			if space_modules.length > 0 and listprices > 0 and user_count > 0 and months > 0
				space_recharge_fee = listprices * (20/3) * user_count * months
				$('#space_recharge_fee')[0].value = space_recharge_fee.toFixed()
			else
				$('#space_recharge_fee')[0].value = ""