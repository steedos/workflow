Template.workflowLayout.onCreated ->
	self = this;

	self.minHeight = new ReactiveVar(
		$(window).height());

	$(window).resize ->
		self.minHeight.set($(window).height());
		if $(window).width()<=1280
			$("body").addClass("sidebar-collapse")
		else
			$("body").removeClass("sidebar-collapse")

Template.workflowLayout.onRendered ->

	self = this;
	self.minHeight.set($(window).height());

	$('body').removeClass('fixed');
	$(window).resize();


Template.workflowLayout.helpers 
	minHeight: ->
		return Template.instance().minHeight.get() + 'px'
	
	subsReady: ->
		return Steedos.subsBootstrap.ready()

Template.workflowLayout.events
	"click #navigation-back": (e, t) ->
		NavigationController.back(); 
