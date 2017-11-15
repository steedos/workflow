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
		if(space && locale){
			// https://cn.steedos.com/applications/designer/current/zh-cn/?spaceId=53215960334904539e00121a
			$("#ifrDesigner").attr("src","/applications/designer/current/" + locale + "/?spaceId=" + space);
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