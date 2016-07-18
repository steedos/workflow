Template.workflow_menu.helpers

    boxName: ->
        if Session.get("box")
            return t(Session.get("box"))

    inbox_count: ->
        badge = Steedos.getBadge("workflow", Session.get("spaceId"))
        if badge
            return badge
        return

    # designer: ->
    #     apps = Steedos.getSpaceApps()
    #     rev = undefined
    #     apps.forEach (i) ->
    #       if i.name == 'Flow Designer'
    #         rev = i

    #     return rev;

