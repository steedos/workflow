Template.tableau_info.helpers
	cost_time_connector: ()->
		url = "tableau/workflow/space/#{Session.get("spaceId")}/cost_time"

		if Meteor.isCordova

			return Meteor.absoluteUrl(url);

		else
			return window.location.origin + "/" + url

Template.tableau_info.onRendered ->
	if Steedos.isPaidSpace()
		this.copyCostTimeTableauUrlClipboard = new Clipboard('.steedos-tableau-approve-cost-time');
		this.copyCostTimeTableauUrlClipboard.on 'success', (e) ->
			toastr.success(t("steedos_tableau_url_copy_success"))
			e.clearSelection()

Template.tableau_info.onDestroyed ->
	this.copyCostTimeTableauUrlClipboard?.destroy();


Template.tableau_info.events
	'click .steedos-tableau-workflow': ()->

		space = db.spaces.findOne({_id: Session.get("spaceId")})

		if space?.admins.includes(Meteor.userId())
			if !Steedos.isPaidSpace()
				toastr.info("标准版只能统计一个月内的数据")

			Modal.show('tableau_flow_list')
		else
			toastr.warning("此功能需要工作区管理员权限")

	'click .steedos-tableau-approve-cost-time': ()->
		if !Steedos.isPaidSpace()
			Steedos.spaceUpgradedModal()
			return;
