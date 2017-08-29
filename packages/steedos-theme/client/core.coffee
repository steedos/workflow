Theme = 
	backgrounds: [{
		name: "flower",
		url: "/packages/steedos_theme/client/background/flower.jpg"
	}, {
		name: "beach",
		url: "/packages/steedos_theme/client/background/beach.jpg"
	}, {
		name: "birds",
		url: "/packages/steedos_theme/client/background/birds.jpg"
	}, {
		name: "books",
		url: "/packages/steedos_theme/client/background/books.jpg"
	}, {
		name: "cloud",
		url: "/packages/steedos_theme/client/background/cloud.jpg"
	}, {
		name: "sea",
		url: "/packages/steedos_theme/client/background/sea.jpg"
	}, {
		name: "fish",
		url: "/packages/steedos_theme/client/background/fish.jpg"
	}],
	logo: "/packages/steedos_theme/client/images/logo.png",
	space_logo: "/packages/steedos_theme/client/images/logo.png",
	icon: "/packages/steedos_theme/client/images/icon.png"

if Meteor.isClient
	Meteor.startup ->
		# 登录窗口标题
		if AccountsTemplates.texts?.title?.signIn
			if Steedos.isMobile()
				AccountsTemplates.texts.title.signIn = "login_title_mobile"
			else
				AccountsTemplates.texts.title.signIn = "login_title"