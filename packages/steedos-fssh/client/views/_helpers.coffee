Portal.helpers =
    Dashboard: ->
        spaceId = Session.get("spaceId")
        dashboardId = Session.get("dashboardId")
        if dashboardId
            return db.portal_dashboards.findOne({_id:dashboardId})
        else
            #fetch the first created dashboard as the dashboard
            dashboard = db.portal_dashboards.findOne({space:spaceId},{sort:{created:1}})
            if dashboard
                Session.set("dashboardId", dashboard._id)
            return dashboard;

    freeboardTemplate: (dashboardId,freeboard)->
        return Portal.autoCompileTemplate.compiledFreeboard dashboardId,freeboard,true

# 自动编译dashboard.freeboard方法集
Portal.autoCompileTemplate =
    timeoutTag:null
    # proxyurl:"https://thingproxy.freeboard.io/fetch/"
    proxyurl:"/api/proxy?fetch="
    ajaxTimeout:1 #timeout seconds for ajax
    compiledFreeboard: (dashboardId,freeboard,isFirstTime)->
        console.log "compiling freeboard...isFirstTime:#{isFirstTime},dashboardId:#{dashboardId}"
        unless dashboardId
            return ""
        if isFirstTime
            $("body").addClass("loading")
            #declare a global variable named dashboardId in datasources so we can fetch the correct datasources later
            Portal.Datasources[dashboardId] = {}
            Meteor.clearTimeout @timeoutTag
            # to exec loadAllDatasource function one second later in the firsttime
            # 这里不可以立刻调用loadAllDatasource函数，其调用结果会被后面的return ""给覆盖了，所以只能延时调用来让return ""先执行
            @loadDatasourceByTime dashboardId,freeboard,1
            console.log "return empty freeboard html in the first time."
            return ""
        else
            compiledFreeboardHtml = @getCompiledFreeboardHtml dashboardId,freeboard,isFirstTime
            contentBox = $ "#freeboard-panes-#{dashboardId}"
            contentBox.empty()
            console.log "will append the freeboard html to #freeboard-panes-#{dashboardId}"
            contentBox.append compiledFreeboardHtml
            $("body").removeClass("loading")
    getCompiledFreeboardHtml: (dashboardId,freeboard,isFirstTime)->
        try
            console.log "getting compiled freeboard html..."
            unless dashboardId
                return ""
            if typeof freeboard == "string"
                freeboard = JSON.parse freeboard
            reHtmls = []
            if freeboard.panes?.length
                freeboard.panes.forEach (pane) ->
                    widgetHtmls =[]
                    if pane.widgets?.length
                        # find widgets that contains settings.html children node only
                        activeWidgets = pane.widgets.filter (n)->
                            return n.settings?.html
                        activeWidgets.forEach (activeWidget) ->
                            html = activeWidget.settings.html
                            widgetClassname = "widget-content"
                            if isFirstTime
                                tempWidgetHtml = "<div class = \"#{widgetClassname}\"></div>"
                            else
                                # 这里把脚本内容中datasources变量变成全局的Portal.Datasources
                                html = html.replace(/\bdatasources\b/g,"Portal.Datasources[\"#{dashboardId}\"]")
                                # 这里执行的是一个传入datasources参数的闭包函数，用来避免变量污染
                                # html脚本内通过Portal.Datasources[dashboardId][datasourceName]来访问ajax请求到的数据
                                evalFunString = "(function(){#{html}})()"
                                try
                                    widgetContentHtml = eval(evalFunString)
                                catch e
                                    # just show the error when catch error
                                    # 这里整个catch中不可以调用t多语言函数，比如t("portal_freeboard_compiling_error")，因为会造成不断重复调用Portal.helpers.freeboardTemplate的死循环
                                    # 这很可能是meteor1.2版本的bug，在1.4中应该已不存在这个问题
                                    console.error "#{pane.title} 在编译脚本时出错"
                                    console.error "#{e.message} <br/> #{e.stack}"
                                    widgetContentHtml = ""
                                tempWidgetHtml = "<div class = \"#{widgetClassname}\">#{widgetContentHtml}</div>"
                            widgetHtmls.push tempWidgetHtml
                    if widgetHtmls.length
                        col_width = parseInt pane.col_width
                        # assume the max col_width is 6(the dafault max col_width of freeboard),then we just need do *2 to match bootstrap's cols rule
                        col_width = col_width*2
                        reHtml = "<div class = \"freeboard-pane col-md-#{col_width}\">#{widgetHtmls.join("")}</div>"
                        reHtmls.push reHtml
            return reHtmls.join ""
        catch e
            console.error "#{pane.title} 在获取编译后的FreeboardHtml时出错"
            console.error "#{e.message} \n #{e.stack}"
            return "";
    replaceParmsToValues: (dashboardId,datasource,content)->
        if content
            # 匹配所有{{}}对里面的内容（内容里面应该是写js脚本，不支持有回车换行的多行脚本）
            # 一般来说，{{}}对里面的脚本会是Portal.GetAuthByName("auth_name").login_name，会调用全局的Portal.GetAuthByName函数根据auth_name返回apps_auth_users记录
            reg = /{{(.|\n)+?}}/g
            content = content.replace(reg,(n)->
                try
                    # 这里用函数闭包的目的只是为了避免变量污染
                    n = n.replace('{{', '').replace('}}', '')
                    # 这里把脚本内容中datasources变量变成全局的Portal.Datasources
                    n = n.replace(/\bdatasources\b/g,"Portal.Datasources[\"#{dashboardId}\"]")
                    result = eval("(function(){return #{n}})()")
                    return result
                catch e
                    # just console the error when catch error
                    # 这里整个catch中不可以调用t多语言函数，比如t("portal_freeboard_compiling_error")，因为会造成不断重复调用Portal.helpers.freeboardTemplate的死循环
                    # 这很可能是meteor1.2版本的bug，在1.4中应该已不存在这个问题
                    console.error "ajax datasource:#{datasource.name} 在编译请求内容脚本时出错:"
                    console.error "#{e.message}\r\n#{e.stack}"
                    return ""
            )
            return content
        else
            return ""
    loadAllDatasource: (dashboardId,freeboard)->
        try
            console.log("trying to loadAllDatasource for dashboardId:#{dashboardId}");
            Meteor.clearTimeout @timeoutTag
            unless dashboardId
                return ""
            if typeof freeboard == "string"
                freeboard = JSON.parse freeboard
            if freeboard.datasources?.length
                freeboard.datasources.forEach (datasource) ->
                    settings = datasource.settings
                    # only when the datasource.settings has name,method,url property at least then try to load it
                    unless settings && settings.method && settings.url
                        return
                    headers = settings.headers
                    use_thingproxy = settings.use_thingproxy
                    body = Portal.autoCompileTemplate.replaceParmsToValues dashboardId,datasource,settings.body
                    url = Portal.autoCompileTemplate.replaceParmsToValues dashboardId,datasource,settings.url
                    url = if use_thingproxy then "#{Portal.autoCompileTemplate.proxyurl}#{window.encodeURIComponent(url)}" else "#{url}"
                    $.ajax
                        type: settings.method
                        async: false
                        url: url
                        data: body
                        timeout: (Portal.autoCompileTemplate.ajaxTimeout * 1000)
                        beforeSend: (XHR) ->
                            if headers?.length
                                headers.forEach (header) ->
                                    XHR.setRequestHeader header.name, header.value
                        success: (result) ->
                            Portal.Events.callBackForAjax(datasource.name,Portal.Datasources[dashboardId][datasource.name],result)
                            Portal.Datasources[dashboardId][datasource.name] = result
                        error: () ->
                            Portal.Datasources[dashboardId][datasource.name] = null
                            console.error "loadAllDatasource faild:#{JSON.stringify(arguments)}"
        catch e
            console.error "loadAllDatasource faild:#{e.message}\r\n#{e.stack}"
        finally
            # try to compile freeboard's js code and show the compiled html after all of the freeboard.datasources is loaded
            @compiledFreeboard dashboardId,freeboard,false
            Portal.autoCompileTemplate.loadDatasourceByTime dashboardId,freeboard
    loadDatasourceByTime: (dashboardId,freeboard,refresh)->
        # get refresh property from freeboard,if nothing then apply the defalut refresh as 5 minute
        unless refresh
            refresh = if freeboard?.refresh then freeboard.refresh else 300
        refresh = refresh*1000
        console.log "loading datasource by time...#{refresh}"
        #启动定时器定时抓取数据源
        @timeoutTag = Meteor.setTimeout (->
            Portal.autoCompileTemplate.loadAllDatasource dashboardId,freeboard
        ), refresh
    getDatasourceNamesFromHtml: (html)->
        # fetch datasources string as array from html,just like ["datasources["hotoa_pending_list"],datasources["hotoa_completed_list"]"]
        datasources = html.match(/datasources\[\"([^\r\n]+)\"\]/g)
        if datasources
            datasourceNames = datasources.map (n) ->
                # fetch datasources key name，just like fetch hotoa_pending_list from datasources["hotoa_pending_list"] then add "widget-datasource-" for prefix
                return "widget-datasource-" + n.match(/\"[^\r\n]+\"/)[0].replace /\"/g, ''
        else
            datasourceNames = []
        return _.uniq datasourceNames



