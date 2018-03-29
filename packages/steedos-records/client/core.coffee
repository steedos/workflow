# import { $ } from 'meteor/jquery';
# import dataTablesBootstrap from 'datatables.net-bs';
# import 'datatables.net-bs/css/dataTables.bootstrap.css';
# dataTablesBootstrap(window, $);

# Tracker.autorun ()->
# 	Steedos.Helpers.setAppTitle(t("records_app_title"));

# Meteor.startup ->
# 	$("body").removeClass("skin-blue").addClass("skin-blue-light")

# Meteor.startup ->
# 	$ ()->
# 		$("body").removeClass("loading")
# 	if Meteor.isClient
# 		db.apps.INTERNAL_APPS = []
