SubsManager.prototype.isLoading = ()->
	this.dep.depend();
	if this.options?.cacheLimit <= 0 
		return false;
	if this._cacheList?.length == 0 
		return false;
	return !this._ready;



Steedos.isLoading = ()->
	# console.log ("Loading state: " + "TabularLoading" + "," + Session.get("TabularLoading") )
	# console.log ("Loading state: " + "Bootstrap" + "," + Steedos.subsBootstrap.isLoading()  )
	# console.log ("Loading state: " + "Space" + "," + Steedos.subsSpace.isLoading()  )
	if Session.get("TabularLoading")
		return true
	if Steedos.subsBootstrap.isLoading() or Steedos.subsSpace.isLoading() 
		return true
	_.each Steedos.subs, (value, key, list)->
		# console.log ("Loading state: " + key + "," + Steedos.subs[key].isLoading()  )
		if Steedos.subs[key].isLoading() 
			return true
	return false

Tracker.autorun (c) ->
	if Steedos.isLoading()
		$("body").addClass("loading")
	else
		$("body").removeClass("loading")
