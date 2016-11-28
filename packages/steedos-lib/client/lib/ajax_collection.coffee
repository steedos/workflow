AjaxCollection = (model, cacheTime) ->
    @model = model
    @cache = new AjaxCollectionCache(model, cacheTime);
    return

AjaxCollection::find = (selector, options) ->
    return @cache.getDataCollection(selector, options, "find").find(selector, options).fetch();

AjaxCollection::findOne = (selector, options) ->
    return @cache.getDataCollection(selector, options, "findone").findOne(selector, options);


