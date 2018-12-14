SubsManager.prototype.isLoading = ()->
	this.dep.depend();
	if this.options?.cacheLimit <= 0 
		return false;
	if this._cacheList?.length == 0 
		return false;
	return !this._ready;



Steedos.isLoading = ()->
	if Session.get("TabularLoading")
		return true
	if Steedos.subsBootstrap.isLoading() or Steedos.subsSpaceBase.isLoading() or Steedos.subsSpace?.isLoading() 
		return true

	for key of Steedos.subs
		if Steedos.subs[key].isLoading() 
			return true

	return false

Meteor.startup ->
	Tracker.autorun (c) ->
		if Steedos.isLoading()
			$("body").addClass("loading")

		#为保险解决loading有时一直不消失的问题延时清除loading
		if !Steedos.isLoading()  
			setTimeout ->
				if !Steedos.isLoading() 
					$("body").removeClass("loading")
			, 500
