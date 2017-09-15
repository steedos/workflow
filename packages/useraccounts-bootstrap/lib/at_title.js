// Simply 'inherites' helpers from AccountsTemplates
Template.atTitle.helpers(AccountsTemplates.atTitleHelpers);

Template.atTitle.helpers({
	subsReady: function(){
		return Steedos.subs["SpaceAvatar"].ready()
	},
	logo: function() {
		debugger;
		// LOGO文件地址在steedos-theme包中的core.coffee中定义
		if(Steedos){
			var spaceId = FlowRouter.current().queryParams.s;
			var space = db.spaces.findOne(spaceId)
			if(space && space.avatar){
				return Steedos.absoluteUrl("/api/files/avatars/@%".replace("@%",space.avatar))
			}
			else{
				var locale = Steedos.locale();
				if (locale === "zh-cn") {
					return Steedos.absoluteUrl(Theme.logo);
				} else {
					return Steedos.absoluteUrl(Theme.logo_en);
				}
			}
		}
		else{
			return Theme.logo;
		}
	}
});

Template.atTitle.onCreated(function(){
	var spaceId = FlowRouter.current().queryParams.s;
	if(!spaceId || !(Steedos && Steedos.subs && Steedos.subs["SpaceAvatar"])){
		return;
	}
	Steedos.subs["SpaceAvatar"].subscribe("space_avatar", spaceId);
});
