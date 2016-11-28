AjaxCollectionCache = (model, cacheTime) ->
    if !cacheTime
        cacheTime = 1000 * 10; #默认缓存10秒，无论服务端是否有变化都从本地中读取
    @cacheTime = cacheTime
    @model = model
    @selectorData= [];
    return

AjaxCollectionCache::GetSelectorCache = (selector) ->
    selectorCache = @selectorData?.findPropertyByPK("selector", JSON.stringify(selector))
    if selectorCache
        return selectorCache
    else
        selectorCache = new Object()
        selectorCache.selector = JSON.stringify(selector)
        selectorCache.data = new Mongo.Collection()
        selectorCache.timestamp = 0
        selectorCache.expirationTime = 0
        @selectorData.push(selectorCache)
        return selectorCache;

AjaxCollectionCache::getDataCollection = (selector, options, api) ->
    cache = @GetSelectorCache(selector);
#    TODO 添加时间戳的判断，与server端数据进行对比来决定是从server获取数据还是从缓存获取
    if cache.timestamp == 0 || (new Date()).getTime() > cache.expirationTime
        @_send selector, options, api
    return cache?.data
    
AjaxCollectionCache::update = (selector, docs, timestamp) ->
    debugger;
    selectorCache = @GetSelectorCache selector
    if docs instanceof Array
        docs.forEach (doc) ->
            local_doc = selectorCache.data.findOne({_id: doc._id});
            if local_doc
                selectorCache.data.update(doc._id, doc)
            else
                selectorCache.data.insert(doc)
    else
        local_doc = selectorCache.data.findOne({_id: docs._id});
        if local_doc
            selectorCache.data.update(docs._id, docs)
        else
            selectorCache.data.insert(docs)
        
    selectorCache.timestamp = timestamp;
    selectorCache.expirationTime = (new Date()).getTime() + @cacheTime

AjaxCollectionCache::_send = (selector, options, api) ->
    that = @
    config =
        model: @model
        selector: selector
        options: options
        space: Session.get('spaceId')
        "X-User-Id": Meteor.userId()
        "X-Auth-Token": Accounts._storedLoginToken()
    rev = undefined
    settings =
        url: Steedos.absoluteUrl() + '/api/collection/' + api
        type: 'POST'
        async: false
        data: JSON.stringify(config)
        dataType: 'json'
        processData: false
        contentType: "application/json"
        success: (data, textStatus) ->
            rev = data
            that.update selector, data.docs, data.timestamp
            return
    $.ajax settings
    return rev



