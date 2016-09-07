AjaxCollection = (model) ->
  @model = model
  return

AjaxCollection::find = (selector, options) ->
  @_send selector, options, 'find'

AjaxCollection::findOne = (selector, options) ->
  @_send selector, options, 'findone'

AjaxCollection::_send = (selector, options, api) ->
  data = 
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
    data: data
    success: (data, textStatus) ->
      rev = data
      return
  $.ajax settings
  return rev