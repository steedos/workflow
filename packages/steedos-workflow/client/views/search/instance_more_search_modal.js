Template.instance_more_search_modal.onRendered(function() {
	$("#instance_more_search_submit_date_start").datetimepicker({
		format: "YYYY-MM-DD"
	});

	$("#instance_more_search_submit_date_end").datetimepicker({
		format: "YYYY-MM-DD"
	});
})

Template.instance_more_search_modal.helpers({
	selected_flow_name: function() {
		flow_id = Session.get('flowId');
		if (flow_id) {
			f = db.flows.findOne(flow_id);
			if (f) {
				return f.name;
			}
		}

		return "";
	}
})

Template.instance_more_search_modal.events({
	'click #instance_more_search_btn': function(event, template) {
		selector = {};

		// if ($('#instance_more_search_key_words').val()) {
		//     var key_words = $('#instance_more_search_key_words').val().split(" ");
		//     var and = [];
		//     _.each(key_words, function(k) {
		//         and.push({
		//             $or: [{
		//                 name: {
		//                     $regex: k
		//                 }
		//             }, {
		//                 applicant_name: {
		//                     $regex: k
		//                 }
		//             }, {
		//                 applicant_organization_name: {
		//                     $regex: k
		//                 }
		//             }]
		//         })
		//     })

		//     selector.$and = and;
		// }

		var and = [];

		if ($('#instance_more_search_name').val()) {
			var name_key_words = $('#instance_more_search_name').val().split(" ");
			_.each(name_key_words, function(k) {
				and.push({
					name: {
						$regex: k
					}
				});
			})
		}

		if (and.length > 0) {
			selector.$and = and;
		}

		if ($('#instance_more_search_applicant_name').val()) {
			selector.applicant_name = {
				$regex: $('#instance_more_search_applicant_name').val()
			};
		}

		if ($('#instance_more_search_applicant_organization_name').val()) {
			selector.applicant_organization_name = {
				$regex: $('#instance_more_search_applicant_organization_name').val()
			};
		}

		var submit_date_start = $('#instance_more_search_submit_date_start').val();
		var submit_date_end = $('#instance_more_search_submit_date_end').val();
		if (submit_date_start && submit_date_end) {
			selector.submit_date = {
				$gte: new Date(submit_date_start),
				$lte: new Date(submit_date_end)
			};
		} else if (submit_date_start && !submit_date_end) {
			selector.submit_date = {
				$gte: new Date(submit_date_start),
				$lte: new Date()
			};
		} else if (!submit_date_start && submit_date_end) {
			selector.submit_date = {
				$gte: new Date(null),
				$lte: new Date(submit_date_end)
			};
		}

		Session.set('instance_more_search_selector', selector);

		Modal.hide(template);
	},

	'click #instance_more_search_flow': function(event, template) {
		Modal.allowMultiple = true;
		Modal.show('flow_list_modal');
	},

	'hide.bs.modal #instance_more_search_modal': function(event, template) {
		Modal.allowMultiple = false;
	}

})
