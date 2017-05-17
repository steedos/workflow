userId = Meteor.userId()

records_search_api = Meteor.absoluteUrl("records/search?userId=#{userId}")

Template.search_records_repository.events
	'click .btn.btn-search':(event)->
		seatch_txt=$('.txt-search.form-control').val()

		if !seatch_txt
			return

		$('.table-responsive').css 'display', 'initial'

		ajaxUrl = records_search_api+'&q='+seatch_txt

		$('.table-records-result').DataTable().ajax.url(ajaxUrl).load();

Template.search_records_repository.onRendered ->
	$('.table-records-result').dataTable({
		'paginate': true, #翻页功能
		'lengthChange': false, #改变每页显示数据数量
		'filter': false, #过滤功能
		'sort': false, #排序功能
		'info': true,  #页脚信息
		'processing': true,
		'language': {
			'thousands': ','    #千级别的数据显示格式
		},
		'pageLength':10,
		'autoWidth': false,#不自动计算列宽度
		'serverSide': true,
		'columns': [
			{ 
				'data': '_source.name',
				render: (val, type, doc) ->
					url = Meteor.absoluteUrl("workflow/space/#{doc?._source?.space}/view/readonly/#{doc?._id}")

					# url = "http://192.168.0.21/workflow/space/#{doc?._source?.space}/view/readonly/#{doc?._id}"

					title = doc.highlight?.name?.join("...") || doc?._source?.name

					highlight = doc.highlight?.values?.join("...") || doc.highlight?.attachments?.join("...")

					applicant_name = doc?._source?.applicant_name

					if !highlight
						highlight = doc?._source?.values

					date = ''

					if doc?._source?.modified
						modified = new Date(doc._source.modified)
						date = modified.getFullYear() + "-" + (modified.getMonth() + 1) + "-" + modified.getDay()

					return """
						<li class="b_algo" data-bm="6">
							<h3>
								<a target="_blank" href="#{url}">
									#{title}
								</a>
							</h3>
							<div class="b_caption">
								<p>#{highlight}</p>
								<div class="b_attribution">
									<cite>
										</i>#{applicant_name}
									</cite>
									<a href="#" aria-haspopup="true">
										<span class="c_tlbxTrg">
											<span class="c_tlbxTrgIcn sw_ddgn"></span>
											<span class="c_tlbxH" ></span>
										</span>
									</a>#{date}
								</div>
							</div>
						</li>
					"""
			}
		],
		# 高版本datatables插件的服务器端分页方法
		'ajax': {
			type: 'get',
			url: records_search_api,
			dataType: 'json'
		},
		# 创建行时候改变行的样式，调样式在这里写
		'createdRow': ( row, data, index )->
			row.removeAttribute("class")
	})
