var designer = {
	urlQuery:function(name){
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if (r != null) return unescape(r[2]);
		return null;
	},
	run:function(){
		var space = this.urlQuery("space");
		var locale = this.urlQuery("locale");
		var flow = this.urlQuery("flow") || '';
		var companyId = this.urlQuery("companyId") || '';
		if(space && locale){
			// https://cn.steedos.com/applications/designer/current/zh-cn/?spaceId=53215960334904539e00121a
			$("#ifrDesigner").attr("src","/applications/designer/current/" + locale + "/?spaceId=" + space + "&flowId=" + flow + "&companyId=" + companyId);
		}
		var Steedos = window.parent.Steedos || null;
		if (Steedos) {
			Steedos.forbidNodeContextmenu(window);
		}
	}
};
$(function(){
	designer.run();
});