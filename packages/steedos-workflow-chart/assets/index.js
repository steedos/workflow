var designer = {
	urlQuery: function(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if (r != null) return unescape(r[2]);
		return null;
	},
	run: function() {
		var instance_id = this.urlQuery("instance_id");
		if (instance_id) {
			// http://192.168.0.60:3000/api/workflow/chart?instance_id=57d11547d77d5e17f8000e54
			$("#ifrChart").attr("src", "/api/workflow/chart?instance_id=" + instance_id);
		}
		var flow_name = this.urlQuery("flow_name");
		if (flow_name) {
			document.title = decodeURIComponent(decodeURIComponent(flow_name));
		}
		var Steedos = window.opener ? window.opener.Steedos : null;
		if (Steedos) {
			// 去除客户端右击事件
			Steedos.forbidNodeContextmenu(window, "#ifrChart");
		}
	}
};
$(function() {
	designer.run();
});