Template.import_users_modal.helpers
	import_simple_url: ()->
		return Steedos.absoluteUrl("excel/steedos_import_users_simple.xls")
	row_number: (i)->
		return i + 1;
	items: ()->
		return Template.instance()?.items.get()

Template.import_users_modal.events
	'change #import-file': (event, template) ->
		items = new Array();
		files = event.currentTarget.files;
		reader = new FileReader();
		reader.onload = (ev) ->
			try
				data = ev.target.result
				workbook = XLSX.read(data, type: 'binary')
			# 存储获取到的数据
			catch e
				console.log '文件类型不正确'
				toastr.error("文件类型不正确")
			# 表格的表格范围，可用于判断表头是否数量是否正确
			fromTo = ''
			# 遍历每张表读取
			for sheet of workbook.Sheets
				if workbook.Sheets.hasOwnProperty(sheet)
					fromTo = workbook.Sheets[sheet]['!ref']
					console.log fromTo
					items = items.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]))
			# break; // 如果只取第一张表，就取消注释这行


			items.forEach (item)->
				if _.has(item, "部门")
					item.organization = item["部门"]
					delete item["部门"]
				if _.has(item, "用户名")
					item.username = item["用户名"]
					delete item["用户名"]
				if _.has(item, "邮箱")
					item.email = item["邮箱"]
					delete item["邮箱"]
				if _.has(item, "姓名")
					item.name = item["姓名"]
					delete item["姓名"]
				if _.has(item, "职务")
					item.position = item["职务"]
					delete item["职务"]
				if _.has(item, "工作电话")
					item.work_phone = item["工作电话"]
					delete item["工作电话"]
				if _.has(item, "手机")
					item.phone = item["手机"]
					delete item["手机"]
				if _.has(item, "状态")
					item.user_accepted = item["状态"]
					delete item["状态"]
				if _.has(item, "排序号")
					item.sort_no = item["排序号"]
					delete item["排序号"]
				if _.has(item, "密码")
					item.password = item["密码"]
					delete item["密码"]

			template.items.set(items)
		reader.readAsBinaryString(files[0]);

	'click #import-user-modal-confirm': (event, template) ->
		if template.items.get().length < 1
			toastr.error("请选择需要导入的数据");
			return

		$("body").addClass("loading")
		Meteor.call("import_users", Session.get("spaceId"), $("#user_pk:checked").val(), template.items.get(), false, (error, result)->
			if error
				toastr.error(error.reason);
			else
				toastr.success("导入已完成")
			Modal.hide(template)
			$.jstree.reference('#steedos_contacts_org_tree').refresh()
			$("body").removeClass("loading")
		);

	'click #import-user-modal-check': (event, template) ->
		if template.items.get().length < 1
			toastr.error("请选择需要导入的数据");
			return

		$("body").addClass("loading")
		Meteor.call("import_users", Session.get("spaceId"), $("#user_pk:checked").val(), template.items.get(), true, (error, result)->
			if error
				toastr.error(error.reason);
			else
				toastr.success("校验通过")
			$("body").removeClass("loading")
		);

Template.import_users_modal.onCreated ()->
	self = this;
	self.items = new ReactiveVar([]);
