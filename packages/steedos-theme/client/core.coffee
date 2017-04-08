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
	}]

Meteor.startup ->
	console.log "fixed"
	$("body").addClass("fixed");