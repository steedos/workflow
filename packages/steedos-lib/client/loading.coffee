SubsManager.prototype.isLoading = ()->
	this.dep.depend();
	if this.options?.cacheLimit <= 0 
		return false;
	if this._cacheList?.length == 0 
		return false;
	return !this._ready;




Tracker.autorun (c) ->
	isLoading = false;
	if Steedos.subsBootstrap.isLoading() or Steedos.subsSpace.isLoading() 
		isLoading = true
	_.each Steedos.subs, (value, key, list)->
		console.log ("Loading state: " + key + "," + Steedos.subs[key].isLoading()  )
		if Steedos.subs[key].isLoading() 
			isLoading = true
	console.log("Loading state: " + isLoading)
	if isLoading
		$("body").addClass("loading")
	else
		$("body").removeClass("loading")
