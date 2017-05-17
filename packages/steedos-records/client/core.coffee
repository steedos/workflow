import { $ } from 'meteor/jquery';
import dataTablesBootstrap from 'datatables.net-bs';
import 'datatables.net-bs/css/dataTables.bootstrap.css';
dataTablesBootstrap(window, $);

# Steedos.setAppTitle "Steedos Records"

Meteor.startup ->
	$("body").css "background-image", "url('/packages/steedos_theme/client/background/birds.jpg')"