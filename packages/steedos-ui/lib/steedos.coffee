SteedosUI = {}

SteedosUI.animationSupport = ->
	animeEnd =
		WebkitAnimation: "webkitAnimationEnd"
		OAnimation: "oAnimationEnd"
		msAnimation: "MSAnimationEnd"
		animation: "animationend"

	transEndEventNames =
		WebkitTransition: "webkitTransitionEnd"
		MozTransition: "transitionend"
		OTransition: "oTransitionEnd otransitionend"
		msTransition: "MSTransitionEnd"
		transition: "transitionend"
	prefixB = transEndEventNames[Modernizr.prefixed("transition")]
	prefixA = animeEnd[Modernizr.prefixed("animation")]
	support = Modernizr.cssanimations
	support: support
	animation: prefixA
	transition: prefixB

SteedosUI.animeBack = (el, callback, type) ->
	el = $(el)
	if not el.length > 0
		callback el if callback
		return
	s = SteedosUI.animationSupport()
	p = ((if type then s.animation else s.transition))
	el.one p, (e) ->
		#el.off(p);
		callback e
		return
	return